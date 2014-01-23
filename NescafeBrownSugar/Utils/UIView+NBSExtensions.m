//
//  UIView+NBSExtensions.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/20/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "UIView+NBSExtensions.h"

@implementation UIView (NBSExtensions)

- (UIImage *)NBS_makeSnapshot {
    CGRect wholeRect = self.bounds;
    
    UIGraphicsBeginImageContextWithOptions(wholeRect.size, YES, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, wholeRect);
    [self.layer renderInContext:ctx];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
