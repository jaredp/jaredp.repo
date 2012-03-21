//
//  Flashcards_NewAppDelegate.h
//  Flashcards New
//
//  Created by Jared Pochtar on 2/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Flashcards_NewViewController;

@interface Flashcards_NewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Flashcards_NewViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Flashcards_NewViewController *viewController;

@end

