//
//  HigherOrderMessage.m
//  SuperMessanger
//
//  Created by Jared Pochtar on 8/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HigherOrderMessage.h"
#import <objc/runtime.h>

@implementation HigherOrderMessage

+ (id)HOMWithGetSignatureForSelector:(NSMethodSignature *(^)(SEL selector))_sig
							 capture:(void (^)(NSInvocation *message))_forward
{
	HigherOrderMessage *message = class_createInstance(self, 0);
	if (message) {
		message->methodSignatureForSelector = [_sig copy];
		message->forward = [_forward copy];
		message->retainCount = 1;
	}
	return [message autorelease];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return methodSignatureForSelector(aSelector);
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	forward(invocation);
}

+ (void)initialize {
	
}

#pragma mark Memory Management

- (id)retain {
	__sync_add_and_fetch(&retainCount, 1);
	return self;
}

- (id)autorelease {
	[NSAutoreleasePool addObject:self];
	return self;
}

- (void)release {
	if (__sync_sub_and_fetch(&retainCount, 1) == 0) {
		[methodSignatureForSelector release];
		[forward release];
		object_dispose(self);
	}
}

@end
