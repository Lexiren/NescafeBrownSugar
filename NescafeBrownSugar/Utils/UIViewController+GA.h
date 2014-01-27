//
//  UIViewController+GA.h
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/27/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NBSGAEventCategoryFacebook = 0,
    NBSGAEventCategoryVkontakte
} NBSGAEventCategory;

typedef enum {
    NBSGAEventActionRegistration = 0,
    NBSGAEventActionShare,
    NBSGAEventActionLike
} NBSGAEventAction;

@interface UIViewController (GA)

- (void)sendEventWithCategory:(NBSGAEventCategory)category action:(NBSGAEventAction)action;

@end
