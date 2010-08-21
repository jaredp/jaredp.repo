//
//  SuperMessanger.h
//  Tokenizer
//
//  Created by Jared Pochtar on 6/20/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import "HigherOrderMessage.h"

@interface SuperMessenger : NSObject {
	struct objc_super target;
	SEL selector;
	size_t frameLength;	
}
+ (void)superMessage:(NSInvocation *)message withTarget:(struct objc_super)objc_super;
+ (void)superMessage:(NSInvocation *)message withObject:(id)object class:(Class)superclass;

+ (SuperMessenger *)messengerWithTarget:(struct objc_super)superStructure;
+ (SuperMessenger *)messengerWithObject:(id)object class:(Class)superclass;

- (id)initWithTarget:(struct objc_super)objc_super;
- (id)initWithObject:(id)object class:(Class)superclass;
- (void)invoke:(NSInvocation *)invoc;

@end

@interface NSInvocation (SuperMessanger)
- (void)invokeWithTarget:(id)target superclass:(Class)superclass;
@end

