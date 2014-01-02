//
//  UIAlertView+NBSExtensions.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (NBSExtensions)

+ (void)showComingSoonAlert;
+ (void)showErrorAlertWithMessage:(NSString *)message;
+ (void)showSimpleAlertWithTitle:(NSString *)title;
+ (void)showSimpleAlertWithMessage:(NSString *)message;
+ (void)showSimpleAlertWithTitle:(NSString *)title message:(NSString *)message;
    
@end
