//
//  NSObject+SuperMessanger.m
//  SuperMessenger
//
//  Created by Jared Pochtar on 8/18/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import "NSObject+SuperMessanger.h"
#import "SuperMessenger.h"

id object_getSuper(id object, Class superclass) {
	return [HigherOrderMessage HOMWithGetSignatureForSelector:^NSMethodSignature *(SEL aSelector) {
		return [object methodSignatureForSelector:aSelector];
	} capture:^(NSInvocation *message) {		
		SEL selector = message.selector;
		if (selector == @selector(super)) {
			id superSuper = object_getSuper(object, class_getSuperclass(superclass));
			[message setReturnValue:&superSuper];
		} else if (selector == @selector(performSelector:) ||
				   selector == @selector(performSelector:withObject:) ||
				   selector == @selector(performSelector:withObject:withObject:)) 
		{
			SEL selectorToPerform;
			[message getArgument:&selectorToPerform atIndex:2];
			id args[2] = { nil, nil };
			switch (message.methodSignature.numberOfArguments) {
				case 4: [message getArgument:&args[0] atIndex:3];
				case 5: [message getArgument:&args[1] atIndex:4];
				default: break;
			}
			id retVal = objc_msgSendSuper(&(struct objc_super){object, superclass}, selectorToPerform, args[0], args[1]);
			[message setReturnValue:&retVal];
		} else {
			[message invokeWithTarget:object superclass:superclass];
		}
	}];
}

@implementation NSObject (SuperMessenger)

+ (id)levelSuperOf:(id)object {
	return [object superWithClass:self];
}

+ (id)superWithClass:(Class)superclass {
	return superclass;
}

- (id)superWithClass:(Class)superclass {
	return object_getSuper(self, superclass);
}

- (id)super {
	return object_getSuper(self, class_getSuperclass(object_getClass(self)));
}


@end
