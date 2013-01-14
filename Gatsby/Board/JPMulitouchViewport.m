//
//  JPMulitouchViewport.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/18/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "JPMulitouchViewport.h"

CGPoint CGRectCenterPoint(CGRect rect) {
	CGFloat x = rect.origin.x + rect.size.width / 2;
	CGFloat y = rect.origin.y + rect.size.height / 2;
	return CGPointMake(x, y);
}

CGPoint CGPointTranslate(CGPoint point, CGPoint delta) {
	return CGPointMake(point.x + delta.x, point.y + delta.y);
}

CGPoint CGPointDelta(CGPoint a, CGPoint b) {
	return CGPointMake(a.x - b.x, a.y - b.y);
}

CGSize CGSizeScale(CGSize size, CGFloat scale) {
	return CGSizeMake(size.width * scale, size.height * scale);
}

CGRect CGRectCenteredInRect(CGRect outerRect, CGSize size) {
	CGFloat deltax = outerRect.size.width - size.width;
	CGFloat deltay = outerRect.size.height - size.height;

	return CGRectMake(outerRect.origin.x + deltax / 2, outerRect.origin.y + deltay / 2, size.width, size.height);
}

CALayer *CALayerOfImage(NSString *name) {
	CALayer *layer = [CALayer layer];
	
	UIImage *image = [UIImage imageNamed:name];
	layer.contents = (id)image.CGImage;
	layer.bounds = (CGRect){.origin = CGPointZero, .size = image.size};
	
	return layer;
}

CGAffineTransform CGTransformRotateAndScaleAround(CGFloat angle, CGFloat scale, CGPoint center) {
	CGAffineTransform t = CGAffineTransformMakeTranslation(center.x, center.y);
	
	t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(angle));
	t = CGAffineTransformConcat(t, CGAffineTransformMakeScale(scale, scale));
	
	t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(-center.x, -center.y));
	return t;
}

@implementation JPMulitouchViewport

- (void)setup {	
	self.multipleTouchEnabled = YES;
	currentTouches = [NSMutableSet set];

	UIImage *background = [UIImage imageNamed:@"background"];

	CALayer *backgroudLayer = [CALayer layer];
	backgroudLayer.contents = (id)background.CGImage;
	backgroudLayer.bounds = self.layer.bounds;
	backgroudLayer.position = CGRectCenterPoint(self.layer.bounds);
	[self.layer addSublayer:backgroudLayer];

	board = [CALayer layer];
	board.bounds = (CGRect){.origin = CGPointZero, .size = background.size};
	board.position = CGRectCenterPoint(self.bounds);
	[self.layer addSublayer:board];

	nonRotatingPieces = [NSMutableSet set];
}

- (void)dontRotate:(CALayer *)layer {
	[nonRotatingPieces addObject:layer];
}

- (void)setCenter:(CGPoint)center rotation:(CGFloat)rotation zoom:(CGFloat)zoom {
	currentAngle = rotation;
	
	CGPoint actualCenter = CGRectCenterPoint(board.bounds);
	CGPoint delta = CGPointDelta(center, actualCenter);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	// would really like a monad about now...	
	
	transform = CGAffineTransformScale(transform, zoom, zoom);
	transform = CGAffineTransformRotate(transform, rotation);
	transform = CGAffineTransformTranslate(transform, -delta.x, -delta.y);
	
	[self setBoardTransform:transform];
}

#pragma mark multitouch

- (struct multitouchInfo)currentMultitouchInfo {
	struct multitouchInfo info;
	
	CGPoint a = [touchA locationInView:self], b = [touchB locationInView:self];
	
	info.center = CGPointMake((a.x + b.x) / 2, (a.y + b.y) / 2);
	info.centerDelta = CGPointDelta(CGRectCenterPoint(self.bounds), info.center);
	
	info.distance = hypotf(a.x - b.x, a.y - b.y);
	info.angle = atanf((a.y - b.y) / (a.x - b.x));
	if ((a.x - b.x) < 0) {
		info.angle = info.angle + M_PI;
	}
	
	return info;
}

- (void)setBoardTransform:(CGAffineTransform)transform {
	CATransform3D sublayerTransform = CATransform3DMakeRotation(-currentAngle, 0, 0, 1.0);
	
	board.affineTransform = transform;
	for (CALayer *sublayer in nonRotatingPieces) {
		sublayer.transform = sublayerTransform;
	}
}

- (void)updateViewport {
	struct multitouchInfo info = [self currentMultitouchInfo];
	CGFloat scale = info.distance / initialTouchInfo.distance;
	CGFloat angle = info.angle - initialTouchInfo.angle;
	CGPoint translation = CGPointDelta(info.center, initialTouchInfo.center);
	
	CGAffineTransform t = startViewMoveTransform;
	
	t = CGAffineTransformConcat(t, CGTransformRotateAndScaleAround(angle, scale,
																   initialTouchInfo.centerDelta));
	t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(translation.x, translation.y));
	
	currentAngle = startViewMoveAngle + angle;
	SansAnimation([self setBoardTransform:t]);
}

- (void)startMultitouch {
	startViewMoveTransform = board.affineTransform;
	startViewMoveAngle = currentAngle;
	
	interactionState = DoubleTouchManipulationInteraction;
	
	NSArray *touches = [currentTouches allObjects];		
	touchA = [touches objectAtIndex:0];
	touchB = [touches objectAtIndex:1];
	
	initialTouchInfo = [self currentMultitouchInfo];
}

- (void)endMultitouch {
	touchA = touchB = nil;
	interactionState = NoInteraction;
}

#pragma mark single touch

- (void)touchDown {
	
}

- (void)touchMoved {
	
}

- (void)touchUp {
	
}

- (void)touchCanceled {
	
}

#pragma mark event handling

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if (interactionState == DoubleTouchManipulationInteraction) {
		[self updateViewport];
	} else if (interactionState == SingleTouchInteraction) {
		[self touchMoved];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[currentTouches unionSet:touches];
	
	if ([currentTouches count] == 1) {
		interactionState = SingleTouchInteraction;
		[self touchDown];
	} else if ([currentTouches count] == 2) {
		if (interactionState == SingleTouchInteraction)
			SansAnimation([self touchCanceled]);
		
		interactionState = DoubleTouchManipulationInteraction;
		[self startMultitouch];
	} else {
		interactionState = NoInteraction;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[currentTouches minusSet:touches];
	
	if (interactionState == SingleTouchInteraction) {
		[self touchUp];
	} else if (interactionState == DoubleTouchManipulationInteraction) {
		[self endMultitouch];
	}
	
	interactionState = NoInteraction;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[currentTouches minusSet:touches];
	
	if (interactionState == SingleTouchInteraction) {
		[self touchCanceled];
	} else if (interactionState == DoubleTouchManipulationInteraction) {
		[self endMultitouch];
	}
	
	interactionState = NoInteraction;
	[self touchesBegan:[NSSet set] withEvent:nil];
}

#pragma mark UIView subclass code

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

@end
