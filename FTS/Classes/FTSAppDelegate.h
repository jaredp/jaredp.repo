//
//  FTSAppDelegate.h
//  FTS
//
//  Created by Jared Pochtar on 7/5/10.
//  Copyright Jared's Software Company 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTSViewController;

@interface FTSAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FTSViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FTSViewController *viewController;

@end

