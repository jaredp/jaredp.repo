//
//  GameView.m
//  Snake
//
//  Created by Jared Pochtar on 2/20/10.
//  Copyright 2010 Hunter College High School. All rights reserved.
//

#import "GameView.h"
#define GRID(pt) grid[pt.x][pt.y]

@implementation GameView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		srand(time(NULL));
		animator = nil;
		food = snakeHead = (point){ 255, 255 };
    }
    return self;
}

- (void)start {
	[animator invalidate];
	
	[self setScore:0];
	
	snakeHeadDirection = up;
	uncommitedDirection = snakeHeadDirection;
	
	point pt;
	for (pt.x = 0; pt.x < gridWidth; pt.x++)
		for (pt.y = 0; pt.y < gridHeight; pt.y++)
			GRID(pt) = (point){ 255, 255 };	
	
	snakeTail = snakeHead = (point){ 30, 0 };
	GRID(snakeTail) = snakeTail;
	
	food.x = rand() % gridWidth;
	food.y = rand() % gridHeight;
	
	animator = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self
											  selector:@selector(refresh)
											  userInfo:nil repeats:YES];
	[self setNeedsDisplay:YES];
}

- (void)refresh {
	snakeHeadDirection = uncommitedDirection;
	point newSnakeHead = snakeHead;
	unsigned char *axis = (snakeHeadDirection & 0x2) != 0 ? &newSnakeHead.y : &newSnakeHead.x;
	*axis += (snakeHeadDirection & 0x1) ? 1 : -1;
	
	point pt = GRID(newSnakeHead);
	if (newSnakeHead.x < gridWidth && newSnakeHead.y < gridHeight && pt.x == 255 && pt.y == 255) {
		[self setNeedsDisplay:YES];
	} else {
		[self end];
	}

	GRID(snakeHead) = newSnakeHead;
	snakeHead = newSnakeHead;
	GRID(snakeHead) = snakeHead;
	
	if (snakeHead.x == food.x && snakeHead.y == food.y) {
		do {
			food.x = rand() % gridWidth;
			food.y = rand() % gridHeight;	
			pt = GRID(food);
		} while (pt.x != 255 && pt.y != 255);
		
		self.score += 10;
		snakeShouldGrow += 10;
	}
	
	if (snakeShouldGrow) {
		snakeShouldGrow--;
	} else {
		point pt = GRID(snakeTail);
		GRID(snakeTail) = (point){ 255, 255 };
		snakeTail = pt;
	}

}

- (void)end {
	[animator invalidate];
	animator = nil;
}

- (void)drawPoint:(point)pt inRect:(NSRect)rect {
	NSRect pointRect = NSMakeRect(NSMinX(rect) + NSWidth(rect) * pt.x / gridWidth,
								  NSMinY(rect) + NSHeight(rect) * pt.y / gridHeight,
								  NSWidth(rect) / gridWidth,
								  NSHeight(rect) / gridHeight);
	NSRectFill(NSInsetRect(pointRect, 2.0, 2.0));
}

- (void)drawRect:(NSRect)dirtyRect {
	NSRect gridRect = NSInsetRect([self bounds], 2.0, 2.0);

	//Draw background + border
	
	[[NSColor whiteColor] set];
	NSRectFill(gridRect);

	[[NSColor blackColor] set];
	NSFrameRect(gridRect);
	
	//Draw Snake
	[[NSColor colorWithDeviceRed:0 green:0 blue:0.5 alpha:1.0] set];
	point pt;
	for (pt.x = 0; pt.x < gridWidth; pt.x++)
		for (pt.y = 0; pt.y < gridHeight; pt.y++) {
			point gridPoint = GRID(pt);
			if (gridPoint.x != 255 || gridPoint.y != 255)
				[self drawPoint:pt inRect:gridRect];
		}
	
	//Draw Food
	
	[[NSColor redColor] set];
	[self drawPoint:food inRect:gridRect];
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
	if ([theEvent keyCode] <= 126 && [theEvent keyCode] >= 123) {
		cardinalDirection keyDirection = [theEvent keyCode] - 123;
		if ((keyDirection & 0x2) != (snakeHeadDirection & 0x2))
		{
			uncommitedDirection = keyDirection;
		}
	} else {
		if ([theEvent keyCode] == 49) {
			[self start];
		}		
	}

}

- (void)setScore:(int)_score {
	score = _score;
	[scoreField setIntValue:score];
}

@synthesize score;
@end
