//
//  HigherOrderMessage.h
//  SuperMessanger
//
//  Created by Jared Pochtar on 8/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HigherOrderMessage {
	Class isa;
	NSUInteger retainCount;

	NSMethodSignature *(^methodSignatureForSelector)(SEL selector);
	void (^forward)(NSInvocation *capture);
}
+ (id)HOMWithGetSignatureForSelector:(NSMethodSignature *(^)(SEL selector))_sig
							 capture:(void (^)(NSInvocation *message))_forward;

- (id)retain;
- (id)autorelease;
- (void)release;

@end
