//
//  UIViewController+GA.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/27/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "UIViewController+GA.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

#define stringFromCategory(enum) [@[@"Facebook", @"Vkontakte"] objectAtIndex:enum]
#define stringFromAction(enum) [@[@"Registration", @"Share", @"Like"] objectAtIndex:enum]

@implementation UIViewController (GA)

- (void)sendEventWithCategory:(NBSGAEventCategory)category action:(NBSGAEventAction)action {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:stringFromCategory(category)
                                                          action:stringFromAction(action)
                                                           label:nil
                                                           value:nil] build]];
}


@end
