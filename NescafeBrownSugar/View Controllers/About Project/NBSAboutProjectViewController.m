//
//  NBSAboutProjectViewController.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/23/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSAboutProjectViewController.h"
#import "NBSDesignAdditions.h"
#import "NBSCommonDefines.h"

NSString *const kNBSAboutProjectVCIdentifier = @"AboutProjectVC";

@interface NBSAboutProjectViewController ()
@property (nonatomic, weak) IBOutlet UITextView *firstTextView;
@property (nonatomic, weak) IBOutlet UITextView *secondTextView;
@property (nonatomic, weak) IBOutlet UILabel *pricesLabel;
@end

@implementation NBSAboutProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!NBS_isIPad) {
        CGFloat delta = NBS_IsDeviceScreenSize4InchOrBigger ? 0 : 2;
        self.firstTextView.font = [UIFont standartLightFontWithSize:16.f - delta];
        self.secondTextView.font = [UIFont standartLightFontWithSize:16.f - delta];
        self.pricesLabel.font = [UIFont standartLightFontWithSize:22.f - delta];
    } else {
        [self.firstTextView replaceFontWithStandartLightFont];
        [self.secondTextView replaceFontWithStandartLightFont];
        [self.pricesLabel replaceFontWithStandartLightFont];
    }
}


@end
