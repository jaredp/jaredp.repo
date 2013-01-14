//
//  JPBoardView.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/14/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "JPBoardView.h"
#import "CocoaExtensions.h"

@implementation JPBoardView
@synthesize currentCard;

- (void)setup {	
	[super setup];

	dots = [NSMutableArray array];
	[self populateSpaces];

	players = [NSMutableArray array];
	
	isNewTurn = YES;
}

- (BGAvatar *)whosTurn {
	return [players objectAtIndex:whosTurn];
}

- (void)touchUp {

/*
	actually do turns, and possibly a bunch of shit here
*/

	if (isNewTurn) {
		isNewTurn = NO;
	
		[CATransaction begin];
		
		BGAvatar *player = [self whosTurn];
		
		[self movePlayer:player forward:player.socialRating];
		[self focusOnSpace:player.space];

		[CATransaction setCompletionBlock:^{
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
				[self playerLandOnSpace];
			});
		}];
		
		[CATransaction commit];
		
	} else if (cardView) {
		if (![currentCard isBlocking]) {
			[self executeCardView];
			[currentCard actOn:[players objectAtIndex:whosTurn]];
			currentCard = nil;
			
			[self nextTurn];
		}
	}
}

- (void)playerLandOnSpace {
	enum SpaceType color = self.whosTurn.space.type;
	if (color == GreenSpace) {
		currentCard = [self dealMoneyCard];
	} else if (color == YellowSpace) {
		currentCard = [self dealGoodsCard];
	} else {
		currentCard = [self dealActionCard];
	}
	
	[self showCard:currentCard];
}

- (void)nextTurn {
	whosTurn = (whosTurn + 1) % players.count;
	isNewTurn = YES;
}

- (void)showCard:(BGCard *)card {
	BGCardViewViewController *cvc = [BGCardViewViewController viewForCard:card];
	cardView = cvc.view;
	
	CGRect destinationFrame = CGRectCenteredInRect(self.superview.bounds, cardView.bounds.size);
	
	CGRect startFrame = destinationFrame;
	startFrame.origin.y = -destinationFrame.size.height;
	cardView.frame = startFrame;
	
	[UIView animateWithDuration:0.2 animations:^{
		[self.superview addSubview:cardView];
		cardView.frame = destinationFrame;
	}];
	
	[UIView commitAnimations];
}

- (void)executeCardView {
	// there should probably be something to the vc about this... or just something in general here -> iPhones?
	[UIView animateWithDuration:0.2 animations:^{
		CGRect frame = cardView.frame;
		frame.origin.y = cardView.superview.frame.size.height;		//below the bottom of the view/screen
		cardView.frame = frame;
	} completion:^(BOOL finished){
		[cardView removeFromSuperview];
		cardView = nil;
	}];
}

- (void)addPlayer:(BGAvatar *)player {
	[players addObject:player];
	[player setBoard:self];
	
	player.money = 500;
	for (int i = 0; i < 5; i++) {
		[player addCard:[self dealGoodsCard]];
	}
	
	player.space = [dots objectAtIndex:0];
	[self movePlayer:player forward:0];
	
	[self dontRotate:player.layer];
	[board addSublayer:player.layer];
	
	[self focusOnPlayer:player];
}

- (void)movePlayer:(BGAvatar *)p forward:(int)spaces {
	BGSpace *nextSpace;
	BGAvatar *occupier;
	do {
		nextSpace = [self spaceForward:spaces fromSpace:p.space];
		spaces += 1; //just in case the last one was occupied
		
		occupier = [self playerOnSpace:nextSpace];
	} while (occupier && occupier != p);
	
	[p setSpace:nextSpace];
}

- (BGAvatar *)playerOnSpace:(BGSpace *)space {
	for (BGAvatar *player in players) {
		if (player.space == space) {
			return player;
		}
	}
	
	return nil;
}

- (BGAvatar *)playerForAvatar:(NSString *)avatar {
	for (BGAvatar *player in players) {
		if ([player.avatar isEqualToString:avatar]) {
			return player;
		}
	}
	
	return nil;
}

- (BGSpace *)spaceForward:(int)spaces fromSpace:(BGSpace *)space {
	int currentPosition = space.tag;
	int nextPosition = (currentPosition + spaces) % dots.count;
	if (nextPosition < 0) nextPosition += dots.count;
	return [dots objectAtIndex:nextPosition];
}

- (void)focusOnPlayer:(BGAvatar *)player {
	[self focusOnSpace:player.space];
}

- (void)focusOnSpace:(BGSpace *)space {
	CGPoint pos = space.position, prev = [self spaceForward:-1 fromSpace:space].position;
	CGPoint delta = CGPointDelta(pos, prev);
	
	CGFloat tan = delta.y / delta.x;
	CGFloat angle = atanf(tan);
	if (delta.x < 0) {
		angle = angle + M_PI;
	}
	
	[self setCenter:pos rotation:-angle zoom:3];	//magic number: depends on board, pieces, spaces
}


- (void)spaceAtX:(float)x y:(float)y color:(enum SpaceType)c {
	BGSpace *space = [BGSpace spaceAt:CGPointMake(x, y) color:c];
	space.tag = dots.count;
	
	[dots addObject:space];
	[board addSublayer:space.layer];
}

- (void)populateSpaces {	
	DISABLE_ANIMATIONS
	
#define spaceAt(xpos, ypos, c) [self spaceAtX:xpos y:ypos color:c];
#include "BGSpaceCode.txt"
	
	REENABLE_ANIMATIONS
}

#pragma mark decks

- (BGGoodsCard *)dealGoodsCard {
	if (goodsDeck.count == 0) {
		goodsDeck = [BGGoodsCard newShuffledDeck];
	}
	
	BGGoodsCard *card = [goodsDeck lastObject];
	[goodsDeck removeLastObject];
	
	return card;
}

- (BGMoneyCard *)dealMoneyCard {
	if (moneyDeck.count == 0) {
		moneyDeck = [BGMoneyCard newShuffledDeck];
	}
	
	BGMoneyCard *card = [moneyDeck lastObject];
	[moneyDeck removeLastObject];
	
	return card;
}

- (BGActionCard *)dealActionCard {
	if (actionDeck.count == 0) {
		actionDeck = [BGActionCard newShuffledDeck];
	}
	
	BGActionCard *card = [actionDeck lastObject];
	[actionDeck removeLastObject];
	
	return card;
}

@end
