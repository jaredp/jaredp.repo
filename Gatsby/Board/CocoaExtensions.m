//
//  CocoaExtensions.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/18/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "CocoaExtensions.h"

@implementation NSMutableArray (Shuffling)

//http://stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray


- (void)shuffle {	
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
