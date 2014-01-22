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
    return NBS_iOSVersionLessThan(@"7.0") ? value : value - kCPInsetCorrectionValue;
}

@implementation UIViewController (NBSNavigationItems)

- (void)setNavigationType:(NBSNavigationType)type {
    UIButton *backButton = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    UIButton *cameraButton = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    NSMutableDictionary *titleAttributes = [self.navigationController.navigationBar.titleTextAttributes mutableCopy];
    
    switch (type) {
        case NBSNavigationTypeWhite: {
            [backButton setImage:[UIImage imageNamed:@"iconBack"] forState:UIControlStateNormal];
            [cameraButton setImage:[UIImage imageNamed:@"iconCameraOff"] forState:UIControlStateNormal];
            [titleAttributes setValue:[UIColor whiteColor] forKey:UITextAttributeTextColor];
            break;
        }
        case NBSNavigationTypeBrown: {
            [backButton setImage:[UIImage imageNamed:@"iconBackBrown"] forState:UIControlStateNormal];
            [cameraButton setImage:[UIImage imageNamed:@"iconCameraOn"] forState:UIControlStateNormal];
            [titleAttributes setValue:[UIColor colorWithRed:93/255.f green:41/255.f blue:0 alpha:1.f]
                               forKey:UITextAttributeTextColor];
            break;
        }
    }
    
    self.navigationController.navigationBar.titleTextAttributes = titleAttributes;
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

- (void)showRightCameraBarButton:(BOOL)showRightCameraBarButton {
    if (showRightCameraBarButton) {
        self.navigationItem.rightBarButtonItem = [self rightCameraBarButtonItem];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (UIButton *)navigateBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"iconBack"]
                    forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    
    [backButton addTarget:self action:@selector(backButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, cpcorrectedInsetValue(kCPBarButtonStandartInset), 0, 0);
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
    leftMenuButton.imageEdgeInsets = UIEdgeInsetsMake(0, cpcorrectedInsetValue(kCPBarButtonStandartInset), 0, 0);
    
    return [self barButtonItemWithButton:leftMenuButton];
}

- (UIBarButtonItem *)rightCameraBarButtonItem {
    UIButton *rightCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightCameraButton addTarget:self
                          action:@selector(rightCameraButtonDidPress:)
                forControlEvents:UIControlEventTouchUpInside];
    [rightCameraButton setImage:[UIImage imageNamed:@"iconCameraOff"]
                       forState:UIControlStateNormal];
    rightCameraButton.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    
    rightCameraButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, cpcorrectedInsetValue(kCPBarButtonStandartInset));
    return [self barButtonItemWithButton:rightCameraButton];
}

#pragma mark - Private

- (void)backButtonDidPress:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)barButtonItemWithButton:(UIButton *)button {
    //button.imageEdgeInsets = UIEdgeInsetsMake(0, cpcorrectedInsetValue(kCPBarButtonStandartInset), 0, 0);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)leftMenuButtonDidPress:(UIButton *)sender {
    [self.sideMenuViewController presentMenuViewController];
}

- (void)rightCameraButtonDidPress:(UIButton *)sender {
}

@end
