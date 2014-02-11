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
    
    NSString *aboutProductText = @"Nescafe 3в1 Brown Sugar - модерновий мобільний додаток для створення власних шедеврів. З ним ти без проблем реалізуєш творчий потенціал!\nЯк він працює?\n- Встанови додаток\n- Авторизуйся через одну із соціальних мереж\n- Вибери малюнок, який хочеш відтвторити\n- Малюй натхненно\n- Ділися з друзями власним шедевром у соціальних мережах\n- Приєднайся до спільноти Nescafe 3в1 в Facebook чи ВКонтакті\n- Набирай більше лайків та отримуй подарунки від нового Nescafe 3в1 Brown Sugar\nЗаряджайся для нових ідей!\nДеталі на сайті: http://brown-sugar.com.ua/ \n";
    
    NSString *aboutPricesText = @"Щотижня отримуй нагоду стати власником фірмовoї футболки від Sekta з власним принтом та запас Nescafe 3в1 Brown Sugar. Не втрачай шанс потішити себе!\n\n";
    
    NSString *appleText = @"*Apple Inc. не є організатором, спонсором, участником та ніяким iншим чином не пов'язана з діючою акцією, що проходить в мобільному додатку Nescafe 3в1 Brown Sugar";
    
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
