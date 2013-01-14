//
//  BGCard.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/19/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "BGCard.h"

@implementation BGCard

@synthesize text;

- (NSString *)viewNibName {
	NSLog(@"error: -[BGCard viewNibName]");
	return @"ActionCard";
}

- (void)actOn:(BGAvatar *)player {
	NSLog(@"error: -[BGCard actOn:]");
}

+ (NSMutableArray *)newShuffledDeck {
	NSLog(@"error: +[BGCard newShuffledDeck]");
	return nil;
}

- (BOOL)isBlocking {
	return NO;
}

@end
