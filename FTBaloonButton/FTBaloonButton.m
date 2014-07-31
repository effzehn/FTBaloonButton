//
//  FTBaloonButton.m
//  BalloonButtonTest
//
//  Created by Andre Hoffmann on 01.08.13.
//  Copyright (c) 2013 Andre Hoffmann. All rights reserved.
//


#import "FTBaloonButton.h"

NSString *FTBaloonIntensityHasChangedNotification = @"FTBaloonIntensityHasChangedNotification";
NSString *kFTBaloonIntensity = @"kFTBaloonIntensity";

static const int MAX_INTENSITY = 100;
static const int MIN_INTENSITY = 1;

@interface FTBaloonButton () {
	CGFloat _saturation;
	CGFloat _brightness;
    CGFloat _hue;
	
	CGFloat _radius;
	
	NSTimer *_growTimer;
	NSTimer *_shrinkTimer;
}

@end


@implementation FTBaloonButton

- (void)awakeFromNib
{
	self.intensity = 1;
    
    self.color = self.tintColor;
    
    [self.color getHue:&(_hue) saturation:NULL brightness:NULL alpha:NULL];
	
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
	CGContextSetFillColorWithColor(ctx, [[UIColor colorWithHue:_hue saturation:_saturation brightness:0.9 alpha:1.0] CGColor]);
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

- (void)setColor:(UIColor *)color
{
    if (color) {
        _color = color;
    }
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
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FTBaloonIntensityHasChangedNotification
														object:nil
													  userInfo:@{kFTBaloonIntensity:[NSNumber numberWithInt:self.intensity]}];
}

- (void)decrementCounter
{
	self.intensity -= 1;
	if (self.intensity == MIN_INTENSITY) {
		[_shrinkTimer invalidate];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FTBaloonIntensityHasChangedNotification
														object:nil
													  userInfo:@{kFTBaloonIntensity:[NSNumber numberWithInt:self.intensity]}];
}

@end