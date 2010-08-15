//
//  NSObject+HigherOrderMessage.m
//  HigherOrderMessage
//
//  Created by Jared Pochtar on 8/13/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import "NSObject+HigherOrderMessage.h"


@implementation NSObject (HigherOrderMessage)

- (id)ifResponds {
	return [HigherOrderMessage HOMWithGetSignatureForSelector:^(SEL selector) {
		return [self methodSignatureForSelector:selector] ?: [NSMethodSignature signatureWithObjCTypes:"@@:"];
	} capture:^(NSInvocation *message) {
		[message invokeWithTarget:([self respondsToSelector:message.selector] ? self : nil)];
	}];
}

@end
