//
//  BGSpace.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/18/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "BGSpace.h"
#import <QuartzCore/QuartzCore.h>

@implementation BGSpace
@synthesize position, type, layer, tag;

CGColorRef green, yellow, red;

#define DOT_RADIUS 15

+ (void)initialize {
	green = [UIColor greenColor].CGColor;
	yellow = [UIColor yellowColor].CGColor;
	red = [UIColor redColor].CGColor;
}

+ (BGSpace *)spaceAt:(CGPoint)point color:(enum SpaceType)color {
	BGSpace *this = [BGSpace new];
	
	this->position = point;
	this->type = color;
	
		
	CAShapeLayer *dot = [CAShapeLayer layer];
	
	CGPathRef circlePath = CGPathCreateWithEllipseInRect(CGRectMake(-DOT_RADIUS, -DOT_RADIUS, DOT_RADIUS * 2, DOT_RADIUS * 2), NULL);
	dot.path = circlePath;
	CGPathRelease(circlePath);
	
	dot.position = point;
	dot.fillColor = (CGColorRef[]){green, yellow, red}[color];
	
	this->layer = dot;
	
	return this;
}

@end
