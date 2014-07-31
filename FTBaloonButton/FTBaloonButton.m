//
//  WLBaloonButton.m
//  BalloonButtonTest
//
//  Created by Andre Hoffmann on 01.08.13.
//  Copyright (c) 2013 xx-well.com. All rights reserved.
//


#import "WLBaloonButton.h"

NSString *WLBaloonIntensityHasChangedNotification = @"WLBaloonIntensityHasChangedNotification";
NSString *kWLBaloonIntensity = @"kWLBaloonIntensity";

static const int MAX_INTENSITY = 100;
static const int MIN_INTENSITY = 1;

@interface WLBaloonButton () {
	CGFloat _saturation;
	CGFloat _brightness;
	
	CGFloat _radius;
	
	NSTimer *_growTimer;
	NSTimer *_shrinkTimer;
}

@end


@implementation WLBaloonButton

- (void)awakeFromNib
{
	self.intensity = 1;
	
	UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
	[longPressGestureRecognizer setNumberOfTouchesRequired:1];
	[longPressGestureRecognizer setMinimumPressDuration:0.1];
	[longPressGestureRecognizer setDelegate:self];
	[self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextBeginPath(ctx);
	CGContextAddArc(ctx, self.frame.size.width / 2, self.frame.size.height / 2, _radius, 0, 2 * M_PI, 0);
	CGContextSetFillColorWithColor(ctx, [[UIColor colorWithHue:1.0 saturation:_saturation brightness:0.9 alpha:1.0] CGColor]);
	CGContextClosePath(ctx);
	CGContextFillPath(ctx);
}

- (void)setIntensity:(NSUInteger)intensity
{
	if (_intensity <= MAX_INTENSITY) {
		if (_intensity < MIN_INTENSITY) {
			_intensity = MIN_INTENSITY;
		} else {
			(_intensity = intensity);
		}
	} else {
		_intensity = MAX_INTENSITY;
	}
	
	_radius = log(_intensity + 1) * 22;
	_saturation = _intensity / 100.0;
	
	NSLog(@"%f", _radius);
	
	[self setNeedsDisplay];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateBegan) {
		[_shrinkTimer invalidate];
		_growTimer = [NSTimer scheduledTimerWithTimeInterval:0.04
													  target:self
													selector:@selector(incrementCounter)
													userInfo:nil
													 repeats:YES];
	}
	
	if (gesture.state == UIGestureRecognizerStateEnded) {
		[_growTimer invalidate];
		_shrinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.04
														target:self
													  selector:@selector(decrementCounter)
													  userInfo:nil
													   repeats:YES];
	}
}

- (void)incrementCounter
{
	self.intensity += 1;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:WLBaloonIntensityHasChangedNotification
														object:nil
													  userInfo:@{kWLBaloonIntensity:[NSNumber numberWithInt:self.intensity]}];
}

- (void)decrementCounter
{
	self.intensity -= 1;
	if (self.intensity == MIN_INTENSITY) {
		[_shrinkTimer invalidate];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:WLBaloonIntensityHasChangedNotification
														object:nil
													  userInfo:@{kWLBaloonIntensity:[NSNumber numberWithInt:self.intensity]}];
}

@end