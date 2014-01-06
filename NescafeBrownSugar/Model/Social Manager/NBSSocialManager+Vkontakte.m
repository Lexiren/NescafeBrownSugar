//
//  NBSSocialManager+Vkontakte.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/3/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSocialManager+Vkontakte.h"
#import "UIAlertView+NBSExtensions.h"
#import "VKUser.h"
#import "NBSUser.h"

#define kNBSVkontakteAppIDPlistKey @"VkontakteAppID"
#define kNBSVkontakteUserDataRequestSignature @"UserDataRequest"

@implementation NBSSocialManager (Vkontakte) 

- (void)vkontakteLoginWithCompletion:(NBSCompletionBlock)completion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *vkontakteAppID = [infoDictionary objectForKey:kNBSVkontakteAppIDPlistKey];
    VKConnector *vkConnector = [VKConnector sharedInstance];
    [vkConnector startWithAppID:vkontakteAppID permissons:@[@"wall", @"groups"]];
    vkConnector.delegate = self;
    self.loginCompletion = completion;
}

- (BOOL)isVkontakteLoggedIn {
    return [VKUser currentUser].accessToken != nil;
}

- (void)getVkontakteUserDataWithCompletion:(NBSCompletionBlockWithUserData)completion {
    self.userDataCompletion = completion;
    VKRequest *request = [VKUser currentUser].info;
    request.signature = kNBSVkontakteUserDataRequestSignature;
    request.offlineMode = YES;
    request.delegate = self;
    [request start];
}

#pragma mark - VKRequestDelegate methods

- (void)VKRequest:(VKRequest *)request
         response:(id)response {
    if ([request.signature isEqualToString:kNBSVkontakteUserDataRequestSignature]) {
        response = [response objectForKey:@"response"];
        if ([response isKindOfClass:[NSArray class]]) {
            NSDictionary *userData = [response firstObject];
            NBSUser *user = [NBSUser currentUser];
            user.vkontakteAvatar = [userData objectForKey:@"photo_100"];
            user.vkontakteFirstName = [userData objectForKey:@"first_name"];
            user.vkontakteLastName = [userData objectForKey:@"last_name"];
            [self performUserDataCompletionWithSuccess:YES
                                                 error:nil
                                                  user:user];
        }
    }
}

- (void)     VKRequest:(VKRequest *)request
connectionErrorOccured:(NSError *)error {
    if ([request.signature isEqualToString:kNBSVkontakteUserDataRequestSignature]) {
        [self performUserDataCompletionWithSuccess:NO
                                             error:error
                                              user:nil];
    }
}

- (void)  VKRequest:(VKRequest *)request
parsingErrorOccured:(NSError *)error {
    if ([request.signature isEqualToString:kNBSVkontakteUserDataRequestSignature]) {
        [self performUserDataCompletionWithSuccess:NO
                                             error:error
                                              user:nil];
    }
}

- (void)   VKRequest:(VKRequest *)request
responseErrorOccured:(id)error {
    if ([request.signature isEqualToString:kNBSVkontakteUserDataRequestSignature]) {
        [self performUserDataCompletionWithSuccess:NO
                                             error:nil
                                              user:nil];
    }
    NSLog(@"Error in response from Vkontakte = %@", [error description]);
}

#pragma mark - VKConnectorDelegate methods

- (void)        VKConnector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken {
    [self performLoginCompletionWithSuccess:YES error:nil];
}

- (void)     VKConnector:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken {
    [self performLoginCompletionWithSuccess:NO error:nil];
}

- (void)   VKConnector:(VKConnector *)connector
connectionErrorOccured:(NSError *)error {
    [self performLoginCompletionWithSuccess:NO error:error];
}

- (void)VKConnector:(VKConnector *)connector
parsingErrorOccured:(NSError *)error {
    [self performLoginCompletionWithSuccess:NO error:error];
}

@end
