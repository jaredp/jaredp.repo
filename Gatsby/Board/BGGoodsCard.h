//
//  BGCard.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/18/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGCard.h"

@interface BGGoodsCard : BGCard

@property enum CardCategory {
	AlcoholCard,
	RealEstateCard,
	ClothingCard,
	GoodToShowOffCard,
	GiftCard,
	DecorationCard,
	TransportationCard,
	
	CardCategoryCount
} category;

@property int value;

@end
