//
//  BGAvatar.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/18/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "BGAvatar.h"
#import "JPCommController.h"
#import "JPNSDataStream.h"
#import "JPBoardView.h"
#import "BGActionCard.h"

@implementation BGAvatar
@synthesize layer;
@synthesize money, cards;
@synthesize gkID;
@synthesize board;

#define AVATAR_SIZE 35

- (id)init {
	cards = [NSMutableArray new];
	return self;
}

- (int)socialRating {
	int categories[CardCategoryCount];
	memset(categories, 0, sizeof(categories));
	
	for (BGGoodsCard *card in cards) {
		categories[card.category] += card.value;
	}
	
	int sum = money * money;
	for (int i = 0; i < CardCategoryCount; i++) {
		sum += categories[i] * categories[i];		// square each category
	}
	
	int rating = sqrt(sum);
	
	// normalize:
	return sqrt((float)rating / 500) * 2.3 + 1;
}

- (void)setAvatar:(NSString *)imageName {
	avatar = imageName;

	layer = [CALayer layer];
	
	UIImage *image = [UIImage imageNamed:imageName];
	layer.contents = (id)image.CGImage;
	layer.bounds = CGRectMake(0, 0, AVATAR_SIZE, AVATAR_SIZE);
}

- (NSString *)avatar {
	return avatar;
}

- (void)addCard:(BGGoodsCard *)card {
	[cards addObject:card];
	[self syncHandheldCards];
}

- (void)setSpace:(BGSpace *)_space {
	space = _space;
	layer.position = space.position;
}

#pragma commands

- (NSArray *)cardsForIndexes:(NSArray *)indexes {
	NSMutableArray *selectedcards = [NSMutableArray arrayWithCapacity:indexes.count];
	for (NSNumber *cardIndex in indexes) {
		[selectedcards addObject:[cards objectAtIndex:cardIndex.integerValue]];
	}
	return selectedcards;
}

- (void)useCards:(NSArray *)selectedcards {
	BGActionCard *action = (BGActionCard *)[board currentCard];
	if (board.whosTurn == self && [action isKindOfClass:[BGActionCard class]]) {
		if (action.requirements.money < money && [action satisfyWithCards:selectedcards]) {
			self.money -= action.requirements.money;
			[cards removeObjectsInArray:selectedcards];
			[self syncHandheldCards];
			
			[board executeCardView];
			[board nextTurn];
		} else {
			[board movePlayer:self forward:-10];
		}
	}
}

- (void)tradeCards:(NSArray *)chosenCards to:(NSString *)whom forPrice:(int)price {
	NSLog(@"trade from %@ to %@ of %@ for %d", avatar, whom, chosenCards, price);

	BGAvatar *otherPlayer = [board playerForAvatar:whom];
	
	[otherPlayer->cards addObjectsFromArray:chosenCards];
	[cards removeObjectsInArray:chosenCards];
	
	[self syncHandheldCards];
	[otherPlayer syncHandheldCards];
	
	self.money += price;
	otherPlayer.money -= price;
}

#pragma mark comm

- (void)handleCommData:(NSData *)data {
	JPNSDataReadStream *stream = [JPNSDataReadStream new];
	stream.data = data;
	
	switch ([stream readChar]) {
		case 'U': {
			[self useCards:[self cardsForIndexes:[stream read]]];
			break;
		}
		case 'T': {
			NSString *toWhom = [stream read];
			int price = [stream readInt];
			NSArray *chosenCards = [self cardsForIndexes:[stream read]];
			[self tradeCards:chosenCards to:toWhom forPrice:price];
		}
		default:
			break;
	}
}

- (void)tellHandheld:(NSData *)data {
	JPCommController *comm = [JPCommController sharedController];
	[comm tell:self data:data];
}

- (void)setMoney:(int)_money {
	money = _money;

	JPNSDataWriteStream *stream = [JPNSDataWriteStream new];
	
	[stream writeChar:'$'];
	[stream writeInt:money];
	
	[self tellHandheld:stream.data];
}

- (void)syncHandheldCards {
	JPNSDataWriteStream *stream = [JPNSDataWriteStream new];
	
	[stream writeChar:'C'];
	NSArray *cardKeys = [NSArray arrayWithObjects:@"text", nil];
	
	NSMutableArray *cardsDictionary = [NSMutableArray array];
	for (BGCard *card in cards) {
		[cardsDictionary addObject:[stream dictionaryForObject:card keys:cardKeys]];
	}
	
	[stream writeNSArray:cardsDictionary];
	
	[self tellHandheld:stream.data];
}

#pragma accessors


- (BGSpace *)space {
	return space;
}

- (int)money {
	return money;
}

@end
