//
//  BGAvatar.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/18/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "BGSpace.h"
#import "BGGoodsCard.h"

@class JPBoardView;

@interface BGAvatar : NSObject {
	NSString *avatar;
	CALayer *layer;
	BGSpace *space;

	NSMutableArray *cards;
	int money;
}

@property __weak JPBoardView *board;

@property NSString *avatar;

@property BGSpace *space;
@property (readonly) CALayer *layer;

@property int money;
@property (readonly) NSArray *cards;
- (void)addCard:(BGGoodsCard *)card;

- (int)socialRating;

- (NSArray *)cardsForIndexes:(NSArray *)indexes;
- (void)useCards:(NSArray *)cards;
- (void)tradeCards:(NSArray *)cards to:(NSString *)whom forPrice:(int)price;


//comm
@property NSString *gkID;
- (void)handleCommData:(NSData *)data;
- (void)tellHandheld:(NSData *)data;
- (void)syncHandheldCards;

@end
