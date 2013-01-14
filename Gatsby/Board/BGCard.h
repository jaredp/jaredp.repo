//
//  BGCard.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaExtensions.h"
@class BGAvatar;

@interface BGCard : NSObject

@property NSString *text;

- (NSString *)viewNibName;

- (void)actOn:(BGAvatar *)player;

+ (NSMutableArray *)newShuffledDeck;

- (BOOL)isBlocking;

@end
