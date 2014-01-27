//
//  NBSGoogleAnalytics.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/27/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NBSGAEventCategoryFacebook = 0,
    NBSGAEventCategoryVkontakte
} NBSGAEventCategory;

typedef enum {
    NBSGAEventActionLogin = 0,
    NBSGAEventActionShare,
    NBSGAEventActionLike
} NBSGAEventAction;

@interface NBSGoogleAnalytics : NSObject

+ (void)sendEventWithCategory:(NBSGAEventCategory)category action:(NBSGAEventAction)action;
+ (void)initGoogleAnalytics;
 
@end
