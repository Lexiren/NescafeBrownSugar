//
//  UIViewController+NBSNavigationItems.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "UIViewController+NBSNavigationItems.h"
#import "NBSNavigationController.h"
#import "UIViewController+RESideMenu.h"
#import "RESideMenu.h"

#define kCPInsetCorrectionValue 10.0
#define kCPBarButtonStandartInset -20.0

static inline CGFloat cpcorrectedInsetValue(CGFloat value)
{
    return SYSTEM_VERSION_LESS_THAN(@"7.0") ? value : value - kCPInsetCorrectionValue;
}

@implementation UIViewController (NBSNavigationItems)

- (void)setupCustomNavigationBarItems {
    if ([self.navigationController isKindOfClass:[NBSNavigationController class]]) {
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.rightBarButtonItem = [(NBSNavigationController *)self.navigationController customRightBarButton];
    }
}

- (void)showLeftMenuBarButton:(BOOL)showLeftMenuBarButton {
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [self navigateBackBarButtonItem];
    } else {
        if (showLeftMenuBarButton) {
            self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
        } else {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
}

- (UIButton *)navigateBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"iconBack"]
                    forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    
    [backButton addTarget:self action:@selector(backButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (UIBarButtonItem *)navigateBackBarButtonItem {
    return [self barButtonItemWithButton:[self navigateBackButton]];
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIButton *leftMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftMenuButton addTarget:self
                       action:@selector(leftMenuButtonDidPress:)
             forControlEvents:UIControlEventTouchUpInside];
    [leftMenuButton setImage:[UIImage imageNamed:@"iconMenu"]
                    forState:UIControlStateNormal];
    leftMenuButton.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    return [self barButtonItemWithButton:leftMenuButton];
}

#pragma mark - Private

- (void)backButtonDidPress:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)barButtonItemWithButton:(UIButton *)button {
    button.imageEdgeInsets = UIEdgeInsetsMake(0, cpcorrectedInsetValue(kCPBarButtonStandartInset), 0, 0);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)leftMenuButtonDidPress:(UIButton *)sender {
    [self.sideMenuViewController presentMenuViewController];
}

@end
