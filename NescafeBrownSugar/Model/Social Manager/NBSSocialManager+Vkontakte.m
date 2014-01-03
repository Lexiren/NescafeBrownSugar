//
//  NBSSocialManager+Vkontakte.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/3/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSocialManager+Vkontakte.h"
#import "UIAlertView+NBSExtensions.h"

#define kNBSVkontakteAppIDPlistKey @"VkontakteAppID"

@implementation NBSSocialManager (Vkontakte) 

- (void)vkontakteLoginWithCompletion:(NBSCompletionBlock)completion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *vkontakteAppID = [infoDictionary objectForKey:kNBSVkontakteAppIDPlistKey];
    VKConnector *vkConnector = [VKConnector sharedInstance];
    [vkConnector startWithAppID:vkontakteAppID permissons:@[@"wall", @"groups"]];
    vkConnector.delegate = self;
}

#pragma mark - Delegate methods

- (void)        VKConnector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken {
    [UIAlertView showSimpleAlertWithMessage:@"Token was got successfuly!"];
}

- (void)     VKConnector:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken {
    [UIAlertView showSimpleAlertWithMessage:NSLocalizedString(@"VkontakteTokenRenewalFailedMessage", nil)];
}

- (void)   VKConnector:(VKConnector *)connector
connectionErrorOccured:(NSError *)error {
    [UIAlertView showErrorAlertWithError:error];
}

- (void)VKConnector:(VKConnector *)connector
parsingErrorOccured:(NSError *)error {
    [UIAlertView showErrorAlertWithError:error];
}

@end
