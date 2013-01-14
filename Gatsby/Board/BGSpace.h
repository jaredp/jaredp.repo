//
//  BGSpace.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/18/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGSpace : NSObject

@property int tag;	//index in the dots NSArray in JPBoardView

@property (readonly) CGPoint position;

@property (readonly) enum SpaceType {
	GreenSpace,
	YellowSpace,
	RedSpace
} type;

@property (readonly) CALayer *layer;

+ (BGSpace *)spaceAt:(CGPoint)point color:(enum SpaceType)color;

@end
