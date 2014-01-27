//
//  NBSGoogleAnalytics.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/27/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSGoogleAnalytics.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

#define stringFromCategory(enum) [@[@"Facebook", @"Vkontakte"] objectAtIndex:enum]
#define stringFromAction(enum) [@[@"Login", @"Share", @"Like"] objectAtIndex:enum]

@implementation NBSGoogleAnalytics

+ (void)sendEventWithCategory:(NBSGAEventCategory)category action:(NBSGAEventAction)action {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:stringFromCategory(category)
                                                          action:stringFromAction(action)
                                                           label:nil
                                                           value:nil] build]];
}

+ (void)initGoogleAnalytics
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    //[GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    //[GAI sharedInstance].dispatchInterval = 20;
    [GAI sharedInstance].dispatchInterval = 1;
    
    
    // Optional: set Logger to VERBOSE for debug information.
    //[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-47118162-1"];
}

@end
