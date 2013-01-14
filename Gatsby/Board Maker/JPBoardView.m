//
//  JPBoardView.m
//  Boardgame
//
//  Created by Jared Pochtar on 4/14/12.
//  Copyright (c) 2012 Devclub. All rights reserved.
//

#import "JPBoardView.h"

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

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180 / M_PI;};

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

@implementation JPBoardView

- (void)setup {	
	self.multipleTouchEnabled = YES;
	currentTouches = [NSMutableSet set];

	UIImage *background = [UIImage imageNamed:@"background"];
	
	board = [CALayer layer];
	board.bounds = (CGRect){.origin = CGPointZero, .size = background.size};
	board.position = CGRectCenterPoint(self.bounds);
	
	[self.layer addSublayer:board];
	
	CALayer *backgroudLayer = [CALayer layer];
	backgroudLayer.contents = (id)background.CGImage;
	backgroudLayer.bounds = (CGRect){.origin = CGPointZero, .size = CGSizeScale(background.size, 2)};
	backgroudLayer.position = CGRectCenterPoint(board.bounds);
	[board addSublayer:backgroudLayer];

	player = CALayerOfImage(@"batman");
	player.bounds = CGRectMake(0, 0, 100, 100);
	player.position = CGPointMake(400, 550);
//	[board addSublayer:player];
	
	dots = [NSMutableArray array];
	
	[self populateSpaces];
}

- (void)spaceAtX:(float)x y:(float)y color:(CGColorRef)c {
	CAShapeLayer *dot = [CAShapeLayer layer];
	
	#define DOT_RADIUS 5
	CGPathRef circlePath = CGPathCreateWithEllipseInRect(CGRectMake(-DOT_RADIUS, -DOT_RADIUS, DOT_RADIUS * 2, DOT_RADIUS * 2), NULL);
	dot.path = circlePath;
	CGPathRelease(circlePath);
	
	dot.position = CGPointMake(x, y);
	dot.fillColor = c;
	
	[board addSublayer:dot];
}

- (void)populateSpaces {
	CGColorRef green = [UIColor greenColor].CGColor;
	CGColorRef yellow = [UIColor yellowColor].CGColor;
	CGColorRef red = [UIColor redColor].CGColor;
	
	DISABLE_ANIMATIONS
	
	#include "BGSpaceCode.txt"
	
	REENABLE_ANIMATIONS
}

- (void)setCenter:(CGPoint)center rotation:(CGFloat)rotation zoom:(CGFloat)zoom {
	currentAngle = rotation;

	CGAffineTransform transform = CGAffineTransformIdentity;
	// would really like a monad about now...	
	
	transform = CGAffineTransformScale(transform, zoom, zoom);
	transform = CGAffineTransformRotate(transform, rotation);
	transform = CGAffineTransformTranslate(transform, -center.x, -center.y);
	
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
	for (CALayer *sublayer in board.sublayers) {
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

- (UIColor *)dotColor {
	UIColor *colors[3] = { [UIColor greenColor],[UIColor yellowColor], [UIColor redColor]};
	return colors[self.dotColorCode];
}

- (NSString *)dotCode:(int)index {
	NSString *colorChar[3] = {@"G", @"Y", @"R"};
	return colorChar[index];
}

#pragma mark single touch
@synthesize dots, dotColorCode;

- (void)touchDown {
	touch = [currentTouches anyObject];

	interactionState = SingleTouchInteraction;
	
	activedot = [CAShapeLayer layer];
	
	CGPathRef circlePath = CGPathCreateWithEllipseInRect(CGRectMake(-5, -5, 10, 10), NULL);
	activedot.path = circlePath;
	CGPathRelease(circlePath);
	
	[activedot setValue:[self dotCode:self.dotColorCode] forKey:@"color_code"];
	activedot.fillColor = self.dotColor.CGColor;

	[self touchMoved];
	[board addSublayer:activedot];
}

- (void)touchMoved {
	SansAnimation(activedot.position = [board convertPoint:[touch locationInView:self]
								   fromLayer:self.layer]);
}

- (void)touchUp {
	[dots addObject:activedot];
	activedot = nil;

	touch = nil;
	interactionState = SingleTouchInteraction;
}

- (void)touchCanceled {
	[activedot removeFromSuperlayer];
	activedot = nil;

	touch = nil;
	interactionState = SingleTouchInteraction;
}

- (IBAction)save:(id)sender {
	NSMutableString *data = [NSMutableString string];
	
	for (CAShapeLayer *dot in dots) {
		
		[data appendFormat:@"\n%f %f %@", dot.position.x, dot.position.y,
										[dot valueForKey:@"color_code"]];
	}
	
	NSLog(@"%@", data);
}

- (IBAction)deleteLast:(id)sender {
	if ([dots count] > 0) {
		CALayer *dot = [dots lastObject];
		[dots removeLastObject];
		[dot removeFromSuperlayer];
	}
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
		[self touchDown];
	} else if ([currentTouches count] == 2) {
		if (interactionState == SingleTouchInteraction)
			SansAnimation([self touchCanceled]);

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
