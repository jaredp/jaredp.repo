//
//  SnakeAppDelegate.h
//  Snake
//
//  Created by Jared Pochtar on 2/20/10.
//  Copyright 2010 Hunter College High School. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SnakeAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
