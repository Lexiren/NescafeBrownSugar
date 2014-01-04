//
//  UIViewController+NBSNavigationItems.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "UIViewController+NBSNavigationItems.h"
#import "NBSNavigationController.h"

@implementation UIViewController (NBSNavigationItems)

- (void)setupCustomNavigationBarItems {
    if ([self.navigationController isKindOfClass:[NBSNavigationController class]]) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        self.navigationItem.rightBarButtonItem = [(NBSNavigationController *)self.navigationController customRightBarButton];
    }
}

@end
