//
//  NewsmagazineAppDelegate.h
//  Newsmagazine
//
//  Created by Jared Pochtar on 3/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsmagazineViewController;

@interface NewsmagazineAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    NewsmagazineViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NewsmagazineViewController *viewController;

@end

