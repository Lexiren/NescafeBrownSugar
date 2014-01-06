//
//  NBSSocialManager+Facebook.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/3/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSocialManager+Facebook.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NBSUser.h"

@implementation NBSSocialManager (Facebook)

- (void)facebookLoginWithCompletion:(NBSCompletionBlock)completion {
    self.loginCompletion = completion;
    if (![self isFacebookLoggedIn]) {
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error)
         {
             [self performLoginCompletionWithSuccess:session.isOpen error:error];
         }];
    }
}

- (BOOL)isFacebookLoggedIn {
    return [FBSession activeSession].isOpen;
}

- (void)getFacebookUserDataWithCompletion:(NBSCompletionBlockWithUserData)completion {
    self.userDataCompletion = completion;
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NBSUser *user = [NBSUser currentUser];
                user.facebookUid = [result objectForKey:@"id"];
                user.facebookFirstName = [result objectForKey:@"first_name"];
                user.facebookLastName = [result objectForKey:@"last_name"];
                [self performUserDataCompletionWithSuccess:YES
                                                     error:nil
                                                      user:user];
            }
        } else {
            [self performUserDataCompletionWithSuccess:NO
                                                 error:error
                                                  user:nil];
        }
    }];
}

@end
