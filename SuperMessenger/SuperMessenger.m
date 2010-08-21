//
//  SuperMessanger.m
//  Tokenizer
//
//  Created by Jared Pochtar on 6/20/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import "SuperMessenger.h"

@implementation SuperMessenger

#define SUPERMESSAGE(method) {																\
int framelength = frameLength;																\
_cmd = selector;																			\
self = (id)&target;																			\
__builtin_return(__builtin_apply((void(*)())method, __builtin_apply_args(), framelength));	\
}																							

- (long long)superMessage SUPERMESSAGE(objc_msgSendSuper)
- (double)superMessageFpret SUPERMESSAGE(objc_msgSendSuper)
- (CGRect)superMessageStret SUPERMESSAGE(objc_msgSendSuper_stret)
//CGRect used to simulate generic struct

- (void)invoke:(NSInvocation *)invoc {
	NSMethodSignature *methodSignature = invoc.methodSignature;
	frameLength = methodSignature.frameLength;
	char retType = methodSignature.methodReturnType[0];

	selector = invoc.selector;
	if (retType == 'd' || retType == 'f') {
		invoc.selector = @selector(superMessageFpret);
	} else if (methodSignature.methodReturnLength > 8) {
		invoc.selector = @selector(superMessageStret);
	} else {
		invoc.selector = @selector(superMessage);
	}
	
	[invoc invokeWithTarget:self];
}

+ (void)superMessage:(NSInvocation *)message withTarget:(struct objc_super)objc_super {
	[[self messengerWithTarget:objc_super] invoke:message];
}

+ (void)superMessage:(NSInvocation *)message withObject:(id)object class:(Class)superclass {
	[[self messengerWithObject:object class:superclass] invoke:message];
}

+ (SuperMessenger *)messengerWithTarget:(struct objc_super)objc_super {
	return [[[self alloc] initWithTarget:objc_super] autorelease];
}

+ (SuperMessenger *)messengerWithObject:(id)object class:(Class)superclass {
	return [[[self alloc] initWithObject:object class:superclass] autorelease];
}

- (id)initWithTarget:(struct objc_super)superStructure {
	if (self = [super init]) {
		target = superStructure;
	}
	return self;
}

- (id)initWithObject:(id)object class:(Class)superclass {
	return [self initWithTarget:(struct objc_super){object, superclass}];
}

@end

@implementation NSInvocation (SuperMessenger)

- (void)invokeWithTarget:(id)target superclass:(Class)superclass {
	[SuperMessenger superMessage:self withObject:target class:superclass];
}

@end
