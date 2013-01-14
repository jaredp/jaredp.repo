//
//  BGActionCard.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "BGCard.h"
#import "BGGoodsCard.h"

@interface BGActionCard : BGCard

struct ActionRequirements {
	int money;
	int goods[CardCategoryCount];
};

@property struct ActionRequirements requirements;
@property BOOL isBlocking;

- (BOOL)satisfyWithCards:(NSArray *)cards;

@end
