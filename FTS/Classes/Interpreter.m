//
//  Interpreter.m
//  FTS
//
//  Created by Jared Pochtar on 7/5/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import "Interpreter.h"
#import "Log.h"
#import <objc/runtime.h>

@implementation Interpreter
/*
 
 the language is as follows (whitespace is completely ignored, except as a separator):
 language: statement*
 block-statement: 
 statement:	identifier '=' expression ';'						|
			'do' statement 'while''('expression')' ';'			|
			'{' statement* '}'									|
			'for''('identifier 'in' expression')' statement		|
			'if''('expression') statement ('else' statement)?	|
			'while''('expression')' statement					|
			expression? ';'										|
 expression: identifier|'['identifier (identifier|(identifier?':'expression)*)']'|string|number|'!'expression|'-'expression
 string: '"'(^['"']|'\"')*'"'
 number: [0-9]*|[0-9]*'.'[0-9]*|'0x'[0-9A-Fa-f]*|'0'[0-7]*|'0b'[0-1]*
 
 //Todo: primatives

 */

- (id)interpretExpressionWithSideEffects:(BOOL)sideEffects {	
	id token;
	if ([tokenizer getNextTokenIfTokenIsIdentifier:&token]) {
		return [variables objectForKey:token];
	} else if ([tokenizer getNextTokenIfTokenIs:@"["]) {
		id target = [self interpretExpressionWithSideEffects:sideEffects];
		NSString *firstSelectorComponent = [tokenizer getIdentifier];
		NSMutableString *selector = sideEffects ? [firstSelectorComponent mutableCopy] : nil;
		NSMutableArray *arguments = sideEffects ? [NSMutableArray array] : nil;
		if (![tokenizer getNextTokenIfTokenIs:@"]"]) {
			[selector appendString:[tokenizer getRequiredToken:@":"]];
			[arguments addObject:[self interpretExpressionWithSideEffects:sideEffects]];
			
			while (![tokenizer getNextTokenIfTokenIs:@"]"]) {
				[selector appendFormat:@"%@:", [tokenizer getIdentifier]];
				[tokenizer getRequiredToken:@":"];
				[arguments addObject:[self interpretExpressionWithSideEffects:sideEffects]];
			}
		}
		
		if (sideEffects) {
			SEL sel = NSSelectorFromString(selector);
			if (![target respondsToSelector:sel] && target) {
				@throw [NSException exceptionWithName:SourceCodeError
											   reason:[NSString stringWithFormat:@"unrecognised selector %c[%@ %@]",
													   target == [target class] ? '+' : '-', [target class], selector]
											 userInfo:nil];
			}
			[selector release];

			NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:sel]];
			invocation.target = target;
			invocation.selector = sel;
			for (int i = 0; i < arguments.count; i++) {
				id argument = [arguments objectAtIndex:i];
				[invocation setArgument:&argument atIndex:i + 2];
			}
			[invocation invoke];
			if (invocation.methodSignature.methodReturnLength > 0) {
				id retval;
				[invocation getReturnValue:&retval];
				return retval;
			}
		} else {
			[selector release];
		}
	} else if ([tokenizer getNextTokenIfTokenIs:@"-"]) {
		return [NSNumber numberWithDouble:-[[self interpretExpressionWithSideEffects:sideEffects] doubleValue]];
	} else if ([tokenizer getNextTokenIfTokenIs:@"!"]) {
		return [self interpretExpressionWithSideEffects:sideEffects] ? nil : [NSNumber numberWithBool:YES];
	} else if ([tokenizer getNextTokenIfTokenIsConstant:&token]) {
		return token;
	} else {
		@throw [NSException exceptionWithName:SourceCodeError
									   reason:[NSString stringWithFormat:@"expected expression"]
									 userInfo:nil];
	}
	
	return nil;
}

- (void)interpretStatementWithSideEffects:(BOOL)sideEffects {
	NSString *identifier;
	if ([tokenizer getNextTokenIfTokenIsIdentifier:&identifier]) {
		if ([tokenizer getNextTokenIfTokenIs:@"="]) {
			id newValue = [self interpretExpressionWithSideEffects:sideEffects];
			if (sideEffects) {
				[variables setValue:newValue forKey:identifier];
			}
		}
		[tokenizer getRequiredToken:@";"];
	} else if ([tokenizer getNextTokenIfTokenIs:@"{"]) {
		while (![tokenizer getNextTokenIfTokenIs:@"}"]) {
			[self interpretStatementWithSideEffects:sideEffects];
		}
	} else if ([tokenizer getNextTokenIfTokenIs:@"if"]) {
		[tokenizer getRequiredToken:@"("];
		BOOL conditional = [self interpretExpressionWithSideEffects:sideEffects] != 0;
		[tokenizer getRequiredToken:@")"];
		[self interpretStatementWithSideEffects:sideEffects && conditional];
		
		if ([tokenizer getNextTokenIfTokenIs:@"else"]) {
			[self interpretStatementWithSideEffects:sideEffects && !conditional];
		}
		
	} else if ([tokenizer getNextTokenIfTokenIs:@"for"]) {
		[tokenizer getRequiredToken:@"("];
		NSString *identifier = [tokenizer getIdentifier];
		[tokenizer getRequiredToken:@"in"];
		id collection = [self interpretExpressionWithSideEffects:sideEffects];
		[tokenizer getRequiredToken:@")"];

		if (sideEffects) {
			if (![collection conformsToProtocol:@protocol(NSFastEnumeration)]) {
				@throw [NSException exceptionWithName:SourceCodeError
											   reason:@"attempted to enumerate over an object which is not a collection"
											 userInfo:nil];
			}
			
			//http://www.mikeash.com/pyblog/friday-qa-2010-04-16-implementing-fast-enumeration.html
			// declare all the local state needed
			NSFastEnumerationState state = { 0 };
			id stackbuf[16];
			BOOL firstLoop = YES;
			long mutationsPtrValue;
			
			// outer loop
			NSUInteger count;
			while((count = [collection countByEnumeratingWithState:&state objects:stackbuf count:sizeof(stackbuf)/sizeof(id)])) {
				if(!firstLoop && mutationsPtrValue != *state.mutationsPtr)
					@throw [NSException exceptionWithName:SourceCodeError reason:@"collection mutated during enumeration" userInfo:nil];
				firstLoop = NO;
				mutationsPtrValue = *state.mutationsPtr;
				
				// inner loop over the array returned by the NSFastEnumeration call
				for(NSUInteger index = 0; index < count; index++) {
					[variables setValue:state.itemsPtr[index] forKey:identifier];
					
					TokenizerPosition loop = tokenizer.position;
					[self interpretStatementWithSideEffects:sideEffects];
					[tokenizer restorePosition:loop];
				}
			}
		}
		
		[self interpretStatementWithSideEffects:NO];

	} else if ([tokenizer getNextTokenIfTokenIs:@"while"]) {
		[tokenizer getRequiredToken:@"("];
		TokenizerPosition loop = tokenizer.position;
		BOOL conditional;
		do {
			[tokenizer restorePosition:loop];
			conditional = [self interpretExpressionWithSideEffects:sideEffects] != nil;
			[tokenizer getRequiredToken:@")"];
			[self interpretStatementWithSideEffects:sideEffects && conditional];
		} while (conditional);
	} else if (![tokenizer getNextTokenIfTokenIs:@";"]) {
		[self interpretExpressionWithSideEffects:sideEffects];
		[tokenizer getRequiredToken:@";"];
	}
}

- (void)interpret:(const char *)source {
	@synchronized (self) {		
		NSMutableCharacterSet *identifierCharachters = [NSMutableCharacterSet alphanumericCharacterSet];
		[identifierCharachters addCharactersInString:@"$_"];
		
		tokenizer = [[Tokenizer alloc] initWithSource:source
							   identifierCharacterSet:identifierCharachters
									 languageKeywords:[NSSet setWithObjects:@"for", @"while", @"else", @"if", @"in", nil]];
		
		//Load the classes into variables -- everything's in one namespace here
		size_t class_count = objc_getClassList(NULL, 0);
		
		variables = [[NSMutableDictionary dictionaryWithCapacity:class_count + 100] retain];
		
		if (class_count > 0) {
			Class *classes = malloc(sizeof(Class) * class_count);
			class_count = objc_getClassList(classes, class_count);
			
			Class badclass = NSClassFromString(@"NSLeafProxy");
			for (int i = 0; i < class_count; i++) {
				//NSMutableDictionary retains objects, not all classes implement +retain
				if (classes[i] != badclass && class_respondsToSelector(classes[i], @selector(retain))) {
					[variables setObject:classes[i] forKey:NSStringFromClass(classes[i])];
				} 
			}
			
			free(classes);
		}
		
		@try {
			while (!tokenizer.isAtEndOfText && !cancel) {
				[self interpretStatementWithSideEffects:YES];
			}
		} @catch (id e) {
			[[NSString stringWithFormat:@"Error: %@", e] log];
		}
		
		[tokenizer release];
		tokenizer = nil;
		
		cancel = NO;
	}
}

- (void)cancel {
	cancel = YES;
}

- (void)dealloc {
	[variables release];
	[tokenizer release];
	[super dealloc];
}

@end
