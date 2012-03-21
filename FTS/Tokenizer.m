//
//  Tokenizer.m
//  FTS
//
//  Created by Jared Pochtar on 7/6/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import "Tokenizer.h"

@implementation Tokenizer
@synthesize currChar;

- (id)initWithSource:(const char *)source identifierCharacterSet:(NSCharacterSet *)idChars 
	languageKeywords:(NSSet *)keywords {
	if (self = [super init]) {
		string = source;
		
		identifierCharacterSet = [idChars retain];
		identiferStartCharacterSet = [identifierCharacterSet mutableCopy];
		[(NSMutableCharacterSet *)identiferStartCharacterSet removeCharactersInString:@"0123456789"];
		
		languageKeywords = [keywords retain];
		currChar = 0;
	}
	return self;
}

- (void)dealloc {
	[identifierCharacterSet release];
	[languageKeywords release];
	[super dealloc];
}

- (void)skipWhitespace {
	static NSCharacterSet *whitespaceCharacters = nil;
	@synchronized (self.class) {
		if (whitespaceCharacters == nil) {
			whitespaceCharacters = [[NSCharacterSet characterSetWithCharactersInString:@" \t\r\n"] retain];
		}
	}
	
	while ([whitespaceCharacters characterIsMember:string[currChar]]){
		currChar++;
	}
	
	if (string[currChar] == '/' && string[currChar + 1] == '/') {
		currChar += 2;
		while (string[currChar++] != '\n');
		[self skipWhitespace];
	}
	
	if (string[currChar] == '/' && string[currChar + 1] == '*') {
		currChar += 2;
		do {
			while (string[currChar++] != '*');
		} while (string[currChar++] != '/');
		[self skipWhitespace];
	}
}

- (BOOL)isAtEndOfText {
	[self skipWhitespace];
	return string[currChar] == '\0';
}

- (BOOL)getAndMapKeyword:(NSDictionary *)map orIdentifier:(SEL)handleIdentifier withHandler:(id)handler {
	
}

- (NSString *)getNextIdentifierOrKeyword {
	[self skipWhitespace];	
	if ([identiferStartCharacterSet characterIsMember:string[currChar]]) {
		size_t startingPoint = currChar, onePastEnd = currChar;
		while ([identifierCharacterSet characterIsMember:string[++onePastEnd]]);
		return [[[NSString alloc] initWithBytes:&string[startingPoint] length:onePastEnd - startingPoint 
									   encoding:NSUTF8StringEncoding] autorelease];
	}			
}

- (NSString *)getRequiredKeyword:(NSString *)requiredKeyword {
	if (![[self getNextIdentifierOrKeyword] isEqual:requiredKeyword]) {
		@throw [NSException exceptionWithName:SourceCodeError
									   reason:[NSString stringWithFormat:@"expected token \"%@\"", requiredKeyword]
									 userInfo:nil];
	}
	return requiredKeyword;	
}

- (BOOL)getNextTokenIfTokenIsIdentifier:(NSString **)identifier {
	NSString *fakeId;
	if (!identifier) {
		identifier = &fakeId;
	}
	
	[self skipWhitespace];	
	if ([identiferStartCharacterSet characterIsMember:string[currChar]]) {
		size_t startingPoint = currChar, onePastEnd = currChar;
		while ([identifierCharacterSet characterIsMember:string[++onePastEnd]]);
		*identifier = [[[NSString alloc] initWithBytes:&string[startingPoint] length:onePastEnd - startingPoint 
											  encoding:NSUTF8StringEncoding] autorelease];
		if (![languageKeywords member:*identifier]) {
			currChar = onePastEnd;
			return YES;
		}		
	} else {
		if (identifier) {
			*identifier = nil;
		}
	}
	
	return NO;
}


- (NSString *)getIdentifier {
	NSString *token;
	if ([self getNextTokenIfTokenIsIdentifier:&token]) {
		return token;
	} else {
		@throw [NSException exceptionWithName:SourceCodeError
									   reason:[NSString stringWithFormat:@"expected identifier, found %@", token]
									 userInfo:nil];			
	}
}

- (BOOL)getNextTokenIfTokenIs:(NSString *)possibleToken {
	[self skipWhitespace];
	for (int i = 0; i < possibleToken.length; i++) {
		if ([possibleToken characterAtIndex:i] != string[currChar + i]) {
			return NO;
		}
	}
	
	currChar += possibleToken.length;
	return YES;
}

- (NSString *)getRequiredToken:(NSString *)requiredToken {
	if (![self getNextTokenIfTokenIs:requiredToken]) {
		@throw [NSException exceptionWithName:SourceCodeError
									   reason:[NSString stringWithFormat:@"expected token \"%@\"", requiredToken]
									 userInfo:nil];
	}
	return requiredToken;
}

#pragma mark Digit Lookups

const signed char hexadecimalDigitValues[256] = {
//	 0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 0
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 1
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 2
	 0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  -1,  -1,  -1,  -1,  -1,  -1,	// 3
	-1, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 4
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 5
	-1, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 6
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 7
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 8
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 9
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // A
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // B
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // C
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // D
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // E
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // F
};

const signed char decimalDigitValues[256] = {
//	 0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 0
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 1
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 2
	 0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  -1,  -1,  -1,  -1,  -1,  -1,	// 3
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 4
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 5
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 6
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 7
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 8
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 9
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // A
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // B
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // C
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // D
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // E
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // F
};

const signed char octalDigitValues[256] = {
//	 0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 0
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 1
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 2
	 0,   1,   2,   3,   4,   5,   6,   7,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,	// 3
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 4
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 5
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 6
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 7
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 8
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 9
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // A
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // B
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // C
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // D
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // E
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // F
};

const signed char binaryDigitValues[256] = {
//	 0    1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 0
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 1
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 2
	 0,   1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,	// 3
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 4
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 5
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 6
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 7
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 8
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // 9
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // A
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // B
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // C
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // D
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // E
	-1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1,  // F
};

- (BOOL)getNextTokenIfTokenIsConstant:(id *)constant {
	id fakeConstant;
	if (!constant) {
		constant = &fakeConstant;
	}
	
	[self skipWhitespace];
	if (decimalDigitValues[(unsigned char)string[currChar]] != -1) {
		int base = 10;
		const signed char *digitValues = decimalDigitValues;		
		if (string[currChar] == '0') {
			switch (string[currChar + 1]) {
				case 'x':
					currChar += 2;
					base = 16;
					digitValues = hexadecimalDigitValues;
					break;
				case 'b':
					currChar += 2;
					base = 2;
					digitValues = binaryDigitValues;
					break;
				default:
					base = 8;
					digitValues = octalDigitValues;
					break;
			}
		}
		
		int integerValue = digitValues[(unsigned char)string[currChar]];
		while (digitValues[(unsigned char)string[++currChar]] != -1) {
			integerValue *= base;
			integerValue += digitValues[(unsigned char)string[currChar]];
		}
		if (string[currChar] == '.') {
			int fractionpart = 0, fractionPlaces = 0;
			while (digitValues[(unsigned char)string[++currChar]] != -1) {
				//Something about this is inaccurate
				fractionPlaces++;
				fractionpart *= base;
				fractionpart += digitValues[(unsigned char)string[currChar]];
			}
			*constant = [NSNumber numberWithDouble:(double)integerValue + (double)fractionpart/pow(base, fractionPlaces)];
		} else {
			*constant = [NSNumber numberWithInt:integerValue];
		}
		
		return YES;
	} else if (string[currChar] == '"') {
		NSMutableString *stringConstant = [NSMutableString string];
		size_t startingPoint = ++currChar;
		while (1) switch (string[++currChar]) {
			default: break;
			case '\\': {
				NSString *segment = [[NSString alloc] initWithBytes:&string[startingPoint]
															 length:currChar - startingPoint 
														   encoding:NSUTF8StringEncoding];				
				switch (string[++currChar]) {
					case '"':	[stringConstant appendFormat:@"%@\"", segment]; break;						
					case 'n':	[stringConstant appendFormat:@"%@\n", segment]; break;
					case '\\':	[stringConstant appendFormat:@"%@\\", segment]; break;
					case 't':	[stringConstant appendFormat:@"%@\t", segment]; break;
					case 'r':	[stringConstant appendFormat:@"%@\r", segment]; break;						
					default:	@throw [NSException exceptionWithName:SourceCodeError
															reason:@"unrecognised escape sequence"
														  userInfo:nil];
				}
				
				[segment release];
			}
			case '"': {
				if (constant) {
					NSString *segment = [[NSString alloc] initWithBytes:&string[startingPoint]
																 length:currChar - startingPoint 
															   encoding:NSUTF8StringEncoding];
					[stringConstant appendString:segment];
					[segment release];
					*constant = stringConstant;
				}
				currChar++;
				return YES;			
			}
			case '\0':
				@throw [NSException exceptionWithName:SourceCodeError reason:@"premature end of file" userInfo:nil];
		}
	}
	
	return NO;
}

@end
