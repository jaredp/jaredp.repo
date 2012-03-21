//
//  GameView.h
//  Snake
//
//  Created by Jared Pochtar on 2/20/10.
//  Copyright 2010 Hunter College High School. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct {
	unsigned char x;
	unsigned char y;
} point;

typedef enum {
	up = 3,
	down = 2,
	right = 1,
	left = 0
} cardinalDirection;

#define gridWidth 61
#define gridHeight 35
//255 x 255 LIMIT! (or change point to short/int[2])
//255, 255 reserved for blank

@interface GameView : NSView {
	IBOutlet NSTextField *scoreField;
	int score;
	NSTimer *animator;
	
	point snakeHead;
	point snakeTail;
	
	point food;
	unsigned int snakeShouldGrow;
	
	cardinalDirection uncommitedDirection;
	cardinalDirection snakeHeadDirection;
	
	point grid[gridWidth][gridHeight];
}
- (void)start;
- (void)refresh;
- (void)end;

@property (assign) int score;
@end
