//
//  FTBiMarque.m
//  BalloonButtonTest
//
//  Created by Andre Hoffmann on 01.08.13.
//  Copyright (c) 2013 Andre Hoffmann. All rights reserved.
//

#import "FTBiMarque.h"
#import "FTBaloonButton.h"

static const int MULTIPLIER = 10;

@interface FTBiMarque () {
		
	NSDictionary *_stringDictionary;
	
	UIView *_containerView;
}

@end



@implementation FTBiMarque

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSDictionary *)labelDictionary
{
    return @{@10:@"easy", @20:@"intermediate", @50:@"advanced", @70:@"heavy", @100:@"intense"};
}

- (void)setIntensity:(NSInteger)intensity
{
	if (intensity > 100) {
		_intensity = 100;
	} else {
		_intensity = intensity;
	}
	
	[self setNeedsDisplay];
}


- (void)handleIntensityChangedNotification:(NSNotification *)notification
{
	self.intensity = roundf([[[notification userInfo] objectForKey:kFTBaloonIntensity] floatValue]);
}


- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIntensityChangedNotification:) name:FTBaloonIntensityHasChangedNotification object:nil];
	
    NSInteger zeroOffset = self.center.x;
	self.intensity = 0;
    self.color = self.tintColor;
    self.textColor = [UIColor grayColor];
	
    _stringDictionary = self.labelDictionary;
	
	_containerView = [[UIView alloc] initWithFrame:self.frame];
	
	[_stringDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		UILabel *label = [[UILabel alloc] init];
		[label setFrame:CGRectMake([key integerValue] * MULTIPLIER + zeroOffset, 5.0, .0, .0)];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setText:(NSString *)obj];
        [label sizeToFit];
		[label setTag:[key integerValue]];
		
		[label setTextColor:self.textColor];
		
		[_containerView addSubview:label];
	}];
	
	[self addSubview:_containerView];
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextBeginPath(ctx);
	CGContextSetStrokeColorWithColor(ctx, [[self color] CGColor]);
	CGContextSetLineWidth(ctx, 2.0f);
	CGContextMoveToPoint(ctx, self.center.x, 10.0);
	CGContextAddLineToPoint(ctx, self.center.x, 22.0);
	CGContextClosePath(ctx);
	CGContextDrawPath(ctx, kCGPathFillStroke);
	
    CGRect newFrame = CGRectMake(-(self.intensity * MULTIPLIER), _containerView.frame.origin.y, _containerView.frame.size.width, _containerView.frame.size.height);
	_containerView.frame = newFrame;
}

- (void)setColor:(UIColor *)color
{
    if (color) {
        _color = color;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if (textColor) {
        _textColor = textColor;
    }
}

@end
