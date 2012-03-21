//
//  Log.h
//  FTS
//
//  Created by Jared Pochtar on 7/5/10.
//  Copyright 2010 Jared's Software Company. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Log : NSObject

+ (void)log:(NSString *)string;
+ (NSString *)output;
+ (void)clear;

@end

@interface NSObject (logging)
- (void)log;
@end

