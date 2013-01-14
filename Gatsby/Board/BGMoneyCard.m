//
//  BGMoneyCard.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "BGMoneyCard.h"
#import "BGAvatar.h"

@implementation BGMoneyCard

@synthesize value;

- (NSString *)text {
	return [NSString stringWithFormat:@"%@\n%c$%d", [super text], (self.value > 0 ? '+' : '-'), abs(self.value)];
}

- (NSString *)viewNibName {
	return @"MoneyCard";
}

- (void)actOn:(BGAvatar *)player {
	player.money += self.value;
}

int randomInRange(int min, int max) {
	return min == max ? max : (rand() % abs(max - min)) + min;
}

+ (NSMutableArray *)newShuffledDeck {
	NSMutableArray *deck = [NSMutableArray array];
	BGMoneyCard *card;
	
#define MakeMoneyCard(txt, min, max)	\
card = [BGMoneyCard new];				\
card.text = txt;						\
card.value = randomInRange(min, max);	\
[deck addObject:card];

#include "MoneyCardsCode.txt"	

#undef MoneyCard

	[deck shuffle];
	return deck;
}

@end
