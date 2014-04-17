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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstTextViewHeightConstraint;
@property (nonatomic, weak) IBOutlet UITextView *firstTextView;
@property (nonatomic, weak) IBOutlet UITextView *secondTextView;
@property (nonatomic, weak) IBOutlet UILabel *pricesLabel;
@end

@implementation NBSAboutProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *aboutProductText = @"Кайфуй від творчості та ділися з друзями натхненням в соціальних мережах. А додаток від \nNescafe 3in1 Brown Sugar — тобі в допомогу!\nЗаряджайся для нових ідей!";
    
    NSString *aboutPricesText = nil;//@"Щотижня отримуй нагоду стати власником фірмовoї футболки від Sekta з власним принтом та запас Nescafe 3в1 Brown Sugar. Не втрачай шанс потішити себе!\n\n";
    
    NSString *appleText = nil;//@"*Apple Inc. не є організатором, спонсором, участником та ніяким iншим чином не пов'язана з діючою акцією, що проходить в мобільному додатку Nescafe 3в1 Brown Sugar";
    
    if (!NBS_isIPad) {
        CGFloat delta = NBS_IsDeviceScreenSize4InchOrBigger ? 0 : 2;
        self.firstTextViewHeightConstraint.constant = (NBS_IsDeviceScreenSize4InchOrBigger) ? 260 : 200;
        self.firstTextView.editable = YES;
        self.secondTextView.editable = YES;
        self.firstTextView.font = [UIFont standartLightFontWithSize:12.f - delta];
        self.secondTextView.font = [UIFont standartLightFontWithSize:12.f - delta];
        
        self.firstTextView.editable = NO;
        self.secondTextView.editable = NO;
        self.pricesLabel.font = [UIFont standartLightFontWithSize:22.f - delta];
        
        self.firstTextView.text = aboutProductText;
        
        UIFont *secondTextViewFont = self.secondTextView.font;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aboutPricesText attributes:@{NSFontAttributeName : secondTextViewFont, NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        
        
        [attributedString appendAttributedString:
         [[NSAttributedString alloc] initWithString:appleText
                                         attributes:@{NSFontAttributeName : [secondTextViewFont fontWithSize:secondTextViewFont.pointSize - 2.], NSForegroundColorAttributeName : [UIColor whiteColor]}]];
        
        self.secondTextView.attributedText = attributedString;
        
        [self.view layoutIfNeeded];
    } else {
        [self.firstTextView replaceFontWithStandartLightFont];
        [self.secondTextView replaceFontWithStandartLightFont];
        [self.pricesLabel replaceFontWithStandartLightFont];
        
        self.firstTextView.editable = YES;
        self.secondTextView.editable = YES;
        self.firstTextView.font = [UIFont standartLightFontWithSize:20.f];
        self.secondTextView.font = [UIFont standartLightFontWithSize:20.f];
        
        self.firstTextView.editable = NO;
        self.secondTextView.editable = NO;
        
        self.firstTextView.text = [[aboutProductText stringByAppendingString:@"\n\n\n"] stringByAppendingString:aboutPricesText];
        self.secondTextView.text = appleText;
    }
    

    
}


@end
