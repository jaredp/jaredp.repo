//
//  CocoaExtensions.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/18/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <Foundation/Foundation.h>


// This category enhances NSMutableArray by providing
// methods to randomly shuffle the elements.
@interface NSMutableArray (Shuffling)
- (void)shuffle;
@end
