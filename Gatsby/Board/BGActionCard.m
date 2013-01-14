//
//  BGActionCard.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "BGActionCard.h"
#import "CocoaExtensions.h"

@implementation BGActionCard
@synthesize requirements, isBlocking;

- (id)init {
	isBlocking = YES;
	return self;
}

- (void)actOn:(BGAvatar *)player {
	//just block
}

- (BOOL)satisfyWithCards:(NSArray *)cards {

	isBlocking = NO;
	return YES;
}

+ (NSMutableArray *)newShuffledDeck {
	NSMutableArray *deck = [NSMutableArray array];

//spaces to move also

#define MakeActionCard(txt, dollars, reqs...) {							\
		BGActionCard *card = [BGActionCard new];						\
		card.text = txt;												\
		struct ActionRequirements r = (struct ActionRequirements){		\
			.money = dollars,											\
			.goods = reqs												\
		};																\
		card.requirements = r;											\
		[deck addObject:card];											\
	}

	MakeActionCard(@"Have a friendly game of tennis with your neighbor", 25, {0, 0, 1, 0, 0, 0, 0})
	MakeActionCard(@"Go to the other Egg for the day", 0, {0, 0, 1, 0, 0, 0, 1})
	MakeActionCard(@"Go to the beach for the day", 20, {0, 0, 1, 0, 0, 0, 0})
	MakeActionCard(@"Throw a party for a friend’s birthday because they have connections that will help you", 0, {1, 0, 0, 0, 1, 0, 0})
	MakeActionCard(@"Go out dancing", 0, {0, 0, 1, 0, 0, 0, 1})
	MakeActionCard(@"Go out to a party", 0, {1, 0, 1, 0, 0, 0, 0})
	MakeActionCard(@"Time to throw a party", 0, {1, 1, 0, 0, 0, 0, 0}) 
	MakeActionCard(@"Time to throw a party", 150, {1, 0, 0, 0, 0, 0, 0})
	MakeActionCard(@"Time to throw a party", 0, {2, 0, 0, 0, 0, 0, 0})
	MakeActionCard(@"Time to throw a party", 0, {1, 0, 1, 0, 0, 0, 0}) 
	MakeActionCard(@"You have a meeting, dress to impress", 50, {0, 0, 1, 0, 0, 0, 0})
	MakeActionCard(@"Meeting your mistress in the city", 75, {0, 0, 0, 0, 0, 0, 1}) 
	MakeActionCard(@"Meeting your mistress in the city", 0, {0, 0, 0, 0, 1, 0, 1}) 
	MakeActionCard(@"Meeting your mistress in the city", 0, {1, 0, 0, 0, 1, 0, 0})
	MakeActionCard(@"Entertaining a small group", 0, {0, 1, 0, 0, 0, 1, 0})
	MakeActionCard(@"Showing off your estate", 0, {0, 0, 0, 10, 0, 0, 0})
	MakeActionCard(@"Going to a friends for Dinner", 0, {1, 0, 1, 0, 0, 0, 0})
	MakeActionCard(@"Time to tee off", 50, {0, 0, 1, 0, 0, 0, 0})
	MakeActionCard(@"You’re having a friendly game a craps", 75, {1, 0, 0, 0, 0, 0, 0})
	MakeActionCard(@"You need to look your best, you're re-meeting 'the one that got away'", 0, {0, 0, 1, 1, 0, 0, 0})

#undef MakeActionCard
	
	[deck shuffle];
	return deck;
}

- (NSString *)viewNibName {
	return @"ActionCard";
}

@end
