//
//  BGCard.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/18/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "BGGoodsCard.h"
#import "BGAvatar.h"

@implementation BGGoodsCard

@synthesize category, value;

- (NSString *)viewNibName {
	return @"GoodCard";
}

- (void)actOn:(BGAvatar *)player {
	[player addCard:self];
}

+ (NSMutableArray *)newShuffledDeck {
	NSMutableArray *goodsDeck = [NSMutableArray array];
	BGGoodsCard *card;
	
#define GoodsCard(cat, val, txt)		\
card = [BGGoodsCard new];				\
card.category = cat;					\
card.value = val;						\
card.text = txt;						\
[goodsDeck addObject:card];
	
	GoodsCard(AlcoholCard, 30, @"Martini (Gin and dry vermouth)")
	GoodsCard(AlcoholCard, 20, @"Gin and Tonic")
	GoodsCard(AlcoholCard, 40, @"The Bronx (Gin, sweet and dry vermouth, and orange juice)")
	GoodsCard(AlcoholCard, 30, @"Pink Murder (Beer, vodka, raspberry ginger ale, and pink lemonade)")
	GoodsCard(AlcoholCard, 30, @"Planter’s Punch (Rum, grenadine, sour mix, pineapple juice, and a maraschino cherry)")
	GoodsCard(AlcoholCard, 30, @"Champagne Punch (Rum, brandy, champagne, sugar, lemons, and orange juice)")
	GoodsCard(AlcoholCard, 30, @"Red Death (Vodka, amaretto, triple sec, sloe gin,and orange and lime juice)")
	GoodsCard(AlcoholCard, 30, @"Mint Julep (Bourbon, mint, and powdered sugar)")
	GoodsCard(AlcoholCard, 30, @"Death by Chocolate (Dark creme de cacao, kahlua, vodka, chocolate syrup, chocolate ice cream)")
	
	GoodsCard(RealEstateCard, 1000, @"Summer Home")
	GoodsCard(RealEstateCard, 400, @"Pool")
	GoodsCard(RealEstateCard, 600, @"Guest Cottage")
	GoodsCard(RealEstateCard, 200, @"Section of Beach")
	
	GoodsCard(ClothingCard, 10, @"Flapper Dress")
	GoodsCard(ClothingCard, 10, @"Dress Pants")
	GoodsCard(ClothingCard, 10, @"Dress Shirt")
	GoodsCard(ClothingCard, 5, @"Dancing Shoes")
	GoodsCard(ClothingCard, 7, @"Fancy Tie")
	GoodsCard(ClothingCard, 15, @"Cuff Links")
	
	GoodsCard(GoodToShowOffCard, 300, @"Sailboat")
	GoodsCard(GoodToShowOffCard, 200, @"Motorboat")
	GoodsCard(GoodToShowOffCard, 50, @"Books")
	GoodsCard(GoodToShowOffCard, 30, @"Candlesticks")
	GoodsCard(GoodToShowOffCard, 40, @"Silverware")
	
	GoodsCard(GiftCard, 20, @"Puppy")
	GoodsCard(GiftCard, 30, @"Jewelry")
	GoodsCard(GiftCard, 20, @"Wrapped Bottle of Champagne")
	
	GoodsCard(DecorationCard, 40, @"Christmas Lights")
	GoodsCard(DecorationCard, 10, @"Candles")
	GoodsCard(DecorationCard, 20, @"Wall Hangings")
	
	GoodsCard(TransportationCard, 15, @"Train ticket")
	GoodsCard(TransportationCard, 300, @"Car")
	GoodsCard(TransportationCard, 200, @"Boat")
	
	[goodsDeck shuffle];
	
#undef GoodsCard

	return goodsDeck;
}

@end
