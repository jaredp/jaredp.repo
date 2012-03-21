//
//  JPZipper.m
//  Finder
//
//  Created by Jared Pochtar on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JPZipper.h"

@implementation JPZipper
@synthesize target, selector, destination, name;

- (id)initWithFilePath:(NSString *)path name:(NSString *)_name {
	if (self = [super init]) {
		path = [path stringByExpandingTildeInPath];
		name = [_name retain];
		
		NSString *tempzipDir = [@"~/Library/Devclub/Odysseus/zips" stringByExpandingTildeInPath];
		destination = [[[tempzipDir stringByAppendingPathComponent:name] stringByAppendingPathExtension:@"zip"] retain];

		zipProcess = [[NSTask alloc] init];
		[zipProcess setLaunchPath:@"/usr/bin/zip"];
		
		[[NSFileManager defaultManager] createDirectoryAtPath:tempzipDir withIntermediateDirectories:YES attributes:nil error:nil];
		
		[zipProcess setCurrentDirectoryPath:[path stringByDeletingLastPathComponent]];
		NSArray *args = [NSArray arrayWithObjects:@"-r", destination, [path lastPathComponent], nil];
		[zipProcess setArguments:args];
		
		[zipProcess setStandardOutput:[NSFileHandle fileHandleWithNullDevice]];
		[zipProcess setStandardError:[NSFileHandle fileHandleWithNullDevice]];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskEnded)
													 name:NSTaskDidTerminateNotification object:zipProcess];
		[zipProcess launch];
	}
	return self;
}

- (void)taskEnded {
	[zipProcess release];
	zipProcess = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[target performSelector:selector withObject:self];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[zipProcess release];
	[destination release];
	self.target = nil;
	
    [super dealloc];
}

@end
