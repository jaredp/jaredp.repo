//
//  JPBoardView.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/14/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#define DISABLE_ANIMATIONS	[CATransaction begin]; [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
#define REENABLE_ANIMATIONS [CATransaction commit];

#define SansAnimation(action...) ({	\
	DISABLE_ANIMATIONS	\
	action;				\
	REENABLE_ANIMATIONS \
})

@interface JPBoardView : UIView {
	CALayer *board;
	CALayer *player;
	
	CGFloat currentAngle;	// used to rotate board.sublayers -theta
	
	enum {
		NoInteraction,
		SingleTouchInteraction,
		DoubleTouchManipulationInteraction
	} interactionState;
	NSMutableSet *currentTouches;
	
	//handle multitouch viewport change
	UITouch *touchA, *touchB;

	CGAffineTransform startViewMoveTransform;
	CGFloat startViewMoveAngle;

	struct multitouchInfo {
		CGFloat distance;
		CGPoint center;
		CGPoint centerDelta;
		CGFloat angle;
	} initialTouchInfo;
	
	//handle single touch
	CAShapeLayer *activedot;
	UITouch *touch;
	
	NSMutableArray *dots;
}

- (void)setup;
//- (void)updateViewport;

- (void)setCenter:(CGPoint)center rotation:(CGFloat)angle zoom:(CGFloat)zoom;

- (struct multitouchInfo)currentMultitouchInfo;

- (void)updateViewport;
- (void)startMultitouch;
- (void)endMultitouch;

- (void)setBoardTransform:(CGAffineTransform)transform;

- (void)touchDown;
- (void)touchMoved;
- (void)touchUp;
- (void)touchCanceled;

- (IBAction)save:(id)sender;
- (IBAction)deleteLast:(id)sender;

@property (readonly) NSArray *dots;
@property char dotColorCode;
// 0 = Green
// 1 = Yellow
// 2 = Red

- (UIColor *)dotColor;
- (NSString *)dotCode:(int)index;

- (void)populateSpaces;
- (void)spaceAtX:(float)x y:(float)y color:(CGColorRef)c;

@end
