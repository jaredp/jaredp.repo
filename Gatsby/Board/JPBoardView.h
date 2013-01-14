//
//  JPBoardView.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/14/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JPMulitouchViewport.h"
#import "BGSpace.h"
#import "BGAvatar.h"
#import "BGGoodsCard.h"
#import "BGMoneyCard.h"
#import "BGActionCard.h"
#import "BGCardViewViewController.h"

@interface JPBoardView : JPMulitouchViewport {
	NSMutableArray *dots;
	
	NSMutableArray *players;
	int whosTurn;
	
	NSMutableArray *goodsDeck;
	NSMutableArray *moneyDeck;
	NSMutableArray *actionDeck;
	
	UIView *cardView;
	BGCard *currentCard;
	
	BOOL isNewTurn;
}

- (BGAvatar *)whosTurn;
- (void)nextTurn;
- (void)playerLandOnSpace;

- (void)populateSpaces;
- (void)spaceAtX:(float)x y:(float)y color:(enum SpaceType)c;

- (BGAvatar *)playerForAvatar:(NSString *)avatar;
- (BGAvatar *)playerOnSpace:(BGSpace *)space;
- (BGSpace *)spaceForward:(int)spaces fromSpace:(BGSpace *)space;

- (void)addPlayer:(BGAvatar *)player;
- (void)movePlayer:(BGAvatar *)p forward:(int)spaces;

- (void)focusOnPlayer:(BGAvatar *)player;
- (void)focusOnSpace:(BGSpace *)space;

@property (readonly) BGCard *currentCard;

- (void)showCard:(BGCard *)card;
- (void)executeCardView;

- (BGGoodsCard *)dealGoodsCard;
- (BGMoneyCard *)dealMoneyCard;
- (BGActionCard *)dealActionCard;

@end
