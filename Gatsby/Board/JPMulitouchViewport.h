//
//  JPMulitouchViewport.h
//  Boardgame
//
//  Created by Jared Pochtar on 4/18/12.
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

CGPoint CGRectCenterPoint(CGRect rect);
CGPoint CGPointTranslate(CGPoint point, CGPoint delta);
CGPoint CGPointDelta(CGPoint a, CGPoint b);
CGSize CGSizeScale(CGSize size, CGFloat scale);
CGRect CGRectCenteredInRect(CGRect outerRect, CGSize size);
CALayer *CALayerOfImage(NSString *name);

CGAffineTransform CGTransformRotateAndScaleAround(CGFloat angle, CGFloat scale, CGPoint center);

@interface JPMulitouchViewport : UIView {
	CALayer *board;
	
	NSMutableSet *nonRotatingPieces;
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
}

- (void)setup;

- (void)dontRotate:(CALayer *)layer;

- (struct multitouchInfo)currentMultitouchInfo;
- (void)setCenter:(CGPoint)center rotation:(CGFloat)angle zoom:(CGFloat)zoom;
- (void)setBoardTransform:(CGAffineTransform)transform;

- (void)updateViewport;
- (void)startMultitouch;
- (void)endMultitouch;

- (void)touchDown;
- (void)touchMoved;
- (void)touchUp;
- (void)touchCanceled;

@end
