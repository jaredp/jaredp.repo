//
//  IgnoreAppDelegate.h
//  Ignore
//
//  Created by Jared Pochtar on 10/8/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface IgnoreAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet WebView *webview;
}

@property (assign) IBOutlet NSWindow *window;

@end
