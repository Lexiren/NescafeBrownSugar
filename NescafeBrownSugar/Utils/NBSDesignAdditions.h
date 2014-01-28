//
//  NBSDesignAdditions.h
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/23/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

@interface UILabel (NBSAdditions)

- (void)replaceFontWithStandartFont;
- (void)replaceFontWithStandartLightFont;

@end

@interface UITextView (NBSAdditions)

- (void)replaceFontWithStandartFont;
- (void)replaceFontWithStandartLightFont;

@end

@interface UIFont (NBSAdditions)

+ (UIFont *)standartFontWithSize:(CGFloat)size;
+ (UIFont *)standartLightFontWithSize:(CGFloat)size;

@end

@interface UIColor (NBSAdditions)

+ (UIColor *)darkBrown;

@end

@interface UIView (NBSAdditions)

- (void)makeHalfHeightCornerRadius;

@end
