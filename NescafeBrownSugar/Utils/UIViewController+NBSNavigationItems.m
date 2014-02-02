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
#import "NBSDesignAdditions.h"

#define kCPInsetCorrectionValue 10.0
#define kCPBarButtonStandartInset -10.0
#define kCPDefaultButtonFrame CGRectMake(0.0, 0.0, 30.0, 30.0)

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
            [titleAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            break;
        }
        case NBSNavigationTypeBrown: {
            [backButton setImage:[UIImage imageNamed:@"iconBackBrown"] forState:UIControlStateNormal];
            [cameraButton setImage:[UIImage imageNamed:@"iconCameraOn"] forState:UIControlStateNormal];
            [titleAttributes setValue:[UIColor darkBrown]
                               forKey:NSForegroundColorAttributeName];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
    backButton.frame = kCPDefaultButtonFrame;
    
    [backButton addTarget:self action:@selector(backButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, cpcorrectedInsetValue(kCPBarButtonStandartInset), 0, 0);
    return backButton;
}

- (UIBarButtonItem *)navigateBackBarButtonItem {
    return [self leftBarButtonItemWithButton:[self navigateBackButton]];
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIButton *leftMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftMenuButton addTarget:self
                       action:@selector(leftMenuButtonDidPress:)
             forControlEvents:UIControlEventTouchUpInside];
    [leftMenuButton setImage:[UIImage imageNamed:@"iconMenu"]
                    forState:UIControlStateNormal];
    leftMenuButton.frame = kCPDefaultButtonFrame;
    leftMenuButton.imageEdgeInsets = UIEdgeInsetsMake(0, cpcorrectedInsetValue(kCPBarButtonStandartInset), 0, 0);
    
    return [self leftBarButtonItemWithButton:leftMenuButton];
}

- (UIBarButtonItem *)rightCameraBarButtonItem {
    UIButton *rightCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightCameraButton addTarget:self
                          action:@selector(rightCameraButtonDidPress:)
                forControlEvents:UIControlEventTouchUpInside];
    UIImage *rightCameraButtonImage = [UIImage imageNamed:@"iconCameraOff"];
    [rightCameraButton setImage:rightCameraButtonImage
                       forState:UIControlStateNormal];
    rightCameraButton.frame = (!NBS_isIPad) ? kCPDefaultButtonFrame : CGRectMake(0.f, 0.f, rightCameraButtonImage.size.width, rightCameraButtonImage.size.height);
    
    return [self rightBarButtonItemWithButton:rightCameraButton];
}

#pragma mark - Private

- (void)backButtonDidPress:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)leftBarButtonItemWithButton:(UIButton *)button {
    button.imageEdgeInsets = UIEdgeInsetsMake(0, cpcorrectedInsetValue(kCPBarButtonStandartInset), 0, 0);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)rightBarButtonItemWithButton:(UIButton *)button {
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, cpcorrectedInsetValue(kCPBarButtonStandartInset));
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)leftMenuButtonDidPress:(UIButton *)sender {
    [self.sideMenuViewController presentMenuViewController];
}

- (void)rightCameraButtonDidPress:(UIButton *)sender {
}

@end
