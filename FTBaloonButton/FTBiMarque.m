//
//  WLBiMarque.m
//  BalloonButtonTest
//
//  Created by Andre Hoffmann on 01.08.13.
//  Copyright (c) 2013 xx-well.com. All rights reserved.
//

#import "WLBiMarque.h"
#import "WLBaloonButton.h"

static const int MULTIPLIER = 10;

@interface WLBiMarque () {
		
	NSDictionary *_stringDictionary;
	
	UIView *_containerView;
}

@end



@implementation WLBiMarque

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
    }
	
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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
	self.intensity = roundf([[[notification userInfo] objectForKey:kWLBaloonIntensity] floatValue]);
}

- (void)awakeFromNib
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIntensityChangedNotification:) name:WLBaloonIntensityHasChangedNotification object:nil];
	
	NSInteger zeroOffset = self.center.x;
	self.intensity = 0;
	
	// temp
	_stringDictionary = @{@10:@"leicht", @20:@"mittel", @50:@"mittelschwer", @70:@"schwer", @100:@"intensiv"};
	
	// 100 = max intensity
	CGRectMake(self.frame.origin.x, self.frame.origin.y, 100 * MULTIPLIER, self.frame.size.height);
	_containerView = [[UIView alloc] initWithFrame:self.frame];
	
	[_stringDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		UILabel *label = [[UILabel alloc] init];
		[label setFrame:CGRectMake([key integerValue] * MULTIPLIER + zeroOffset, 5.0, .0, .0)];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setText:(NSString *)obj];
		[label sizeToFit];
		[label setTag:[key integerValue]];
		
		[label setTextColor:[UIColor grayColor]];
		
		[_containerView addSubview:label];
	}];
	
	[self addSubview:_containerView];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextBeginPath(ctx);
	CGContextSetStrokeColorWithColor(ctx, [[UIColor redColor] CGColor]);
	CGContextSetLineWidth(ctx, 2.0f);
	CGContextMoveToPoint(ctx, self.center.x, 10.0);
	CGContextAddLineToPoint(ctx, self.center.x, 22.0);
	CGContextClosePath(ctx);
	CGContextDrawPath(ctx, kCGPathFillStroke);
	
	CGRect newFrame = CGRectMake(-(self.intensity * MULTIPLIER), self.frame.origin.y, _containerView.frame.size.width, _containerView.frame.size.height);
	_containerView.frame = newFrame;
	NSLog(@"%f", newFrame.origin.x);
}


@end
