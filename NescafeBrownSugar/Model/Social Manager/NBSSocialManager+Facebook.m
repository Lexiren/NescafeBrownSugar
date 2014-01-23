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
#import <Social/Social.h>

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

- (void)performSharePhotoCompletionWithSuccess:(BOOL)success error:(NSError *)error data:(id)data {
    if (self.sharePhotoFBCompletion) {
        self.sharePhotoFBCompletion(success, error, data);
        self.sharePhotoFBCompletion = nil;
        self.sharePhoto = nil;
    }
}

- (void)postImageToFB:(UIImage *)image withCompletion:(NBSCompletionBlockWithData)completion {
    self.sharePhotoFBCompletion = completion;
    /*
     * if the current session has no publish permission we need to reauthorize
     */
    if ([[[FBSession activeSession]permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
        
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             if (session.isOpen && !error) {
                                                 [FBSession setActiveSession:session];
                                                 [self postImage:image];
                                             }
                                         }];
    }else{
        [self postImage:image];
    }
}

- (void)postImage:(UIImage *)image {
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@"message text" forKey:@"message"];
    [params setObject:UIImagePNGRepresentation(image) forKey:@"source"];
    [params setValue:@"0" forKey:@"no_store"];
    
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              [self performSharePhotoCompletionWithSuccess:(error == nil)
                                                                     error:error
                                                                      data:result];
                          } ];
}

@end
