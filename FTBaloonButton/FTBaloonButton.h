//
//  WLBaloonButton.h
//  BalloonButtonTest
//
//  Created by Andre Hoffmann on 01.08.13.
//  Copyright (c) 2013 xx-well.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *WLBaloonIntensityHasChangedNotification;
extern NSString *kWLBaloonIntensity;

@interface WLBaloonButton : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSUInteger intensity;


@end
