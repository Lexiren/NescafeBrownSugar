//
//  UIView+NIB.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NIB)

+ (id)loadViewFromNIB;
+ (id)loadViewFromNIBWithFrame:(CGRect)frame;

@end
