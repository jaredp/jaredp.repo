//
//  OdysseusAppDelegate.h
//  Odysseus
//
//  Created by Jared Pochtar on 2/3/11.
//  Copyright 2011 Jared's Software Company. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OdysseusAppDelegate : NSObject

- (void)setValue:(id)value forKey:(NSString *)key inPlist:(NSString *)plistPath;
- (void)wrapFile:(NSString *)fileToWrap;

@end
