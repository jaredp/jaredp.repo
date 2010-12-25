//
//  IgnoreAppDelegate.m
//  Ignore
//
//  Created by Jared Pochtar on 10/8/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import "IgnoreAppDelegate.h"

@implementation IgnoreAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[webview setMainFrameURL:@"http://en.wikipedia.org/wiki/Trojan_horse_(computing)"];
}

@end
