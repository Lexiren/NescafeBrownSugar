//
//  NBSDesignAdditions.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/23/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSDesignAdditions.h"

@implementation UILabel (NBSAdditions)

- (void)replaceFontWithStandartFont {
    self.font = [UIFont fontWithName:@"SansRoundedC" size:self.font.pointSize];
}

- (void)replaceFontWithStandartLightFont {
    self.font = [UIFont fontWithName:@"SansRoundedLightC" size:self.font.pointSize];
}

@end

@implementation UITextView (NBSAdditions)

- (void)replaceFontWithStandartFont {
    self.font = [UIFont fontWithName:@"SansRoundedC" size:self.font.pointSize];
}

- (void)replaceFontWithStandartLightFont {
    self.font = [UIFont fontWithName:@"SansRoundedLightC" size:self.font.pointSize];
}

@end

@implementation UIFont (NBSAdditions)

+ (UIFont *)standartFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"SansRoundedC" size:size];
}

+ (UIFont *)standartLightFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"SansRoundedLightC" size:size];
}

@end

@implementation UIColor (NBSAdditions)

+ (UIColor *)darkBrown {
    return [UIColor colorWithRed:93/255.f green:41/255.f blue:0 alpha:1.f];
}

@end

@implementation UIView (NBSAdditions)

- (void)makeHalfHeightCornerRadius {
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
}

@end
