//
//  UIView+NIB.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "UIView+NIB.h"

@implementation UIView (NIB)

#pragma mark - public
+ (id)loadViewFromNIB {
    NSString *nibName = NSStringFromClass([self class]);
    if (NBS_isIPad) {
        nibName = [nibName stringByAppendingString:@"_iPad"];
    }
    return [self loadViewFromNIBWithName:nibName];
}

+ (id)loadViewFromNIBWithFrame:(CGRect)frame {
    id view = [self loadViewFromNIB];
    [view setFrame:frame];
    [view layoutIfNeeded];
    return view;
}

#pragma mark - private
+ (id)loadViewFromNIBWithName:(NSString *)name {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:name
                                                         owner:nil
                                                       options:nil];
    
    for (UIView *view in nibContents) {
        if ([view isKindOfClass:[self class]]) {
            return view;
        }
    }
    NSAssert(NO, @"Attempt to load view from wrong or corrupted NIB");
    return nil;
}

@end
