//
//  FTBaloonButton
//  BalloonButtonTest
//
//  Created by Andre Hoffmann on 01.08.13.
//  Copyright (c) 2013 Andre Hoffmann. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *FTBaloonIntensityHasChangedNotification;
extern NSString *kFTBaloonIntensity;

@interface FTBaloonButton : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSUInteger intensity;

/**
 Defaults to tintColor of View
 */
@property (nonatomic, strong) UIColor *color;


@end
