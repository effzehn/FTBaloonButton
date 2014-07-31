//
//  FTBiMarque.h
//  BalloonButtonTest
//
//  Created by Andre Hoffmann on 01.08.13.
//  Copyright (c) 2013 Andre Hoffmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTBiMarque : UIView

@property (nonatomic, assign) NSInteger intensity;

/**
 Defaults to tintColor of view
 */
@property (nonatomic, strong) UIColor *color;

/**
 Defaults to grayColor
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 Label caption with intensity as key, while 100 is the maximum value for a key.
 */
@property (nonatomic, strong) NSDictionary *labelDictionary;


@end
