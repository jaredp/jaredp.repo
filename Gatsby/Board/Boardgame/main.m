//
//  main.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/14/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JPAppDelegate.h"

int main(int argc, char *argv[])
{
	@autoreleasepool {
		srandom(time(NULL));
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([JPAppDelegate class]));
	}
}
