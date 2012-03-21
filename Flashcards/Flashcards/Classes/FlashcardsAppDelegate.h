//
//  FlashcardsAppDelegate.h
//  Flashcards
//
//  Created by Jared Pochtar on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlashcardsViewController;

@interface FlashcardsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FlashcardsViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FlashcardsViewController *viewController;

@end

