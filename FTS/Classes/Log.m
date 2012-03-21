//
//  Log.m
//  FTS
//
//  Created by Jared Pochtar on 7/5/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import "Log.h"

@implementation Log

static NSMutableString *output;

+ (void)log:(NSString *)string {
	NSMutableString *output = (NSMutableString *)[self output];
	@synchronized(output) {
		[output appendFormat:@"%@\n", string];
	}
}

+ (NSString *)output {
	@synchronized(self) {
		if (!output) {
			output = [[NSMutableString string] retain];
		}
		return [[output retain] autorelease];
	}
}

+ (void)clear {
	@synchronized(self) {
		[output release];
		output = [[NSMutableString string] retain];
	}
}

@end

@implementation NSObject (logging)

- (void)log {
	[Log log:[self description]];
}

@end


