//
//  JPMenuWithStaticItems.m
//  Notecards
//
//  Created by Jared Pochtar on 11/27/11.
//  Copyright 2011 Devclub. All rights reserved.
//

#import "JPMenuWithStaticItems.h"
#import <objc/runtime.h>

/* UNDOCUMENTED API? */
@interface NSMenu (_itemArray)

- (NSArray *)_itemArray;

@end


@implementation JPMenuWithStaticItems
@synthesize staticMenuToAppend;

- (NSArray *)_itemArray {
	return [[super _itemArray] arrayByAddingObjectsFromArray:[staticMenuToAppend itemArray]];
}

@end

@interface JPPuB : NSPopUpButton
@end


@implementation JPPuB

@end


@implementation JPObjCMsgLogger

+ (void)initialize {
	
}

+ (void)forwardInvocation:(NSInvocation *)invocation {
	NSLog(@"+[<0x%x> %@] -> %s", (size_t)self,
								 NSStringFromSelector([invocation selector]),
								 invocation.methodSignature.methodReturnType);
	 
	[invocation invokeWithTarget:[self classToMonitor]];
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
	return [[self classToMonitor] methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	NSLog(@"-[<0x%x> %@] -> %s", 
		  (size_t)self,
		  NSStringFromSelector([invocation selector]),
		  invocation.methodSignature.methodReturnType);

	[invocation invokeWithTarget:internal];
	
	id this = self;
	SEL selfreturners[] = {
		@selector(retain),
		@selector(autorelease),
		@selector(initWithCoder:),
		@selector(awakeAfterUsingCoder:),
	};
	for (int i = 0; i < sizeof(selfreturners)/sizeof(SEL); i++) {
		if ([invocation selector] == selfreturners[i]) {
			[invocation setReturnValue:&this];
		}
	}
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
	return [internal methodSignatureForSelector:sel];
}

+ (Class)classToMonitor {
	NSLog(@"Incorrect usage of JPObjCMsgLogger.");
	return NULL;
}

+ (id)allocWithZone:(NSZone *)zone {
	JPObjCMsgLogger *this = class_createInstance(objc_getClass("JPObjCMsgLogger"), 0);
	this->internal = [[self classToMonitor] allocWithZone:zone];
	return this;
}

@end

@implementation _JPMenuWithStaticItems

+ (Class)classToMonitor {
	return [JPMenuWithStaticItems class];
}

@end

@implementation NSMenuItem_intercepter

+ (Class)classToMonitor {
	return [NSMenuItem class];
}

@end

@interface NSPopUpButton_intercepter : JPObjCMsgLogger

@end

@implementation NSPopUpButton_intercepter

+ (Class)classToMonitor {
	return [NSPopUpButton class];
}

- (BOOL)isProxy {
	return YES;
}

@end

@interface NSControl (hacking)
@end

@implementation NSControl (hacking)

- (void)mouseDown:(NSEvent *)theEvent {
	NSLog(@"mousedown: %@ - %@", self, theEvent);
	[super mouseDown:theEvent];
}

@end


