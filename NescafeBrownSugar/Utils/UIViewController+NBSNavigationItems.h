//
//  UIViewController+NBSNavigationItems.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NBSNavigationTypeWhite = 0,
    NBSNavigationTypeBrown,
} NBSNavigationType;

@interface UIViewController (NBSNavigationItems)

- (void)setNavigationType:(NBSNavigationType)type;
- (void)showLeftMenuBarButton:(BOOL)showLeftMenuBarButton;
- (void)showRightCameraBarButton:(BOOL)showRightCameraBarButton;

@end
