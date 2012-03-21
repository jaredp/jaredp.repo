//
//  JPModelObject.m
//  Records
//
//  Created by Jared Pochtar on 5/8/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import "JPModelObject.h"


@implementation JPModelObject

+ (id)allocWithZone:(NSZone *)zone {
	JPModelObject *new = [super allocWithZone:zone];
	if (new) new->members = [NSMutableDictionary new];
	return new;
}

- (void)dealloc {
	[members release];
	[super dealloc];
}

- (NSString *)description {
	return [[self className] stringByAppendingString:[members description]];
}

- (void)log {
	NSLog(@"%@", self);
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
	static NSMethodSignature *accessor = nil, *setter = nil;
	if (!accessor) {
		accessor = [[NSMethodSignature signatureWithObjCTypes:"@@:"] retain];
		setter = [[NSMethodSignature signatureWithObjCTypes:"v@:@"] retain];
	}
	NSString *sel = NSStringFromSelector(selector);
	BOOL isSetter = [sel characterAtIndex:sel.length - 1] == ':';
	return isSetter ? setter : accessor;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	NSString *member = NSStringFromSelector([anInvocation selector]);
	int numargs = [[anInvocation methodSignature] numberOfArguments];
	BOOL isSetter = ([[anInvocation methodSignature] numberOfArguments] == 3);
	
	if (isSetter) {
		member = [member substringToIndex:member.length - 1];
		if ([@"set" isEqual:[member substringToIndex:3]]) {
			member = [NSString stringWithFormat:@"%c%@", tolower([member characterAtIndex:3]), [member substringFromIndex:4]];
		}
	}
	
	if (!isSetter) {
		id value = [members objectForKey:member];
		[anInvocation setReturnValue:&value];
	} else {
		id newValue;
		[anInvocation getArgument:&newValue atIndex:2];
		[members setObject:newValue forKey:member];
	}
}

@end
