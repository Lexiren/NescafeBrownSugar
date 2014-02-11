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
    self.firstTextView.text = @"Кайфуй від творчості та ділися з друзями натхненням в соціальних мережах. А додаток від \nNescafe 3в1 Brown Sugar — тобі в допомогу! \nЗаряди свій мозок для нових ідей!";
    self.secondTextView.text = @"Щотижня отримуй нагоду стати власником фірмовoї футболки від Sekta з власним принтом та запас \nNescafe 3в1 Brown Sugar. Не втрачай шанс потішити себе! Стань фаном спiльнот Nescafe 3в1 та бери участь в акції! A ще – не забyдь долучати до голосування друзiв. \nБільше like – більше шансів на перемогу!\n\n*Apple Inc. не є організатором, спонсором, участником та ніяким iншим чином не пов'язана з діючою акцією, що проходить в мобільному додатку Nescafe 3в1 Brown Sugar";
    if (!NBS_isIPad) {
        CGFloat delta = NBS_IsDeviceScreenSize4InchOrBigger ? 0 : 2;
        self.firstTextViewHeightConstraint.constant = (NBS_IsDeviceScreenSize4InchOrBigger) ? 140 : 100;
        self.firstTextView.editable = YES;
        self.secondTextView.editable = YES;
        self.firstTextView.font = [UIFont standartLightFontWithSize:15.f - delta];
        self.secondTextView.font = [UIFont standartLightFontWithSize:15.f - delta];
        
        self.firstTextView.editable = NO;
        self.secondTextView.editable = NO;
        self.pricesLabel.font = [UIFont standartLightFontWithSize:22.f - delta];
        
        [self.view layoutIfNeeded];
    } else {
        [self.firstTextView replaceFontWithStandartLightFont];
        [self.secondTextView replaceFontWithStandartLightFont];
        [self.pricesLabel replaceFontWithStandartLightFont];
    }
}


@end
