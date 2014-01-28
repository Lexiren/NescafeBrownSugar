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
#import "NBSGoogleAnalytics.h"
#import "NBSGalleryImage.h"

#define kNBSFacebookGroupID @"212435355525147"


@implementation NBSSocialManager (Facebook)

- (void)facebookAutologinWithCompletion:(NBSCompletionBlock)completion {
    [self facebookLoginWithAllowLoginUI:NO completion:completion];
}

- (void)facebookLoginWithCompletion:(NBSCompletionBlock)completion {
    [self facebookLoginWithAllowLoginUI:YES completion:completion];
}

- (void)facebookLoginWithAllowLoginUI:(BOOL)allowLoginUI completion:(NBSCompletionBlock)completion {
    self.loginCompletion = completion;
    if (![self isFacebookLoggedIn]) {
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                           allowLoginUI:allowLoginUI
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error)
         {
             if (session.isOpen && !error) {
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNBSShouldAutologinFBDefaultsKey];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                 
                 [NBSGoogleAnalytics sendEventWithCategory:NBSGAEventCategoryFacebook
                                                    action:NBSGAEventActionLogin];
                 
                 [self getFacebookUserDataWithCompletion:^(BOOL success, NSError *error, NBSUser *user) {
                     if (success) {
                        [NBSGalleryImage setNeedUpdateGallery:YES];
                     }
                     [self performLoginCompletionWithSuccess:success error:error];
                 }];
             } else {
                 [self performLoginCompletionWithSuccess:session.isOpen error:error];
             }

         }];
    }
}

- (BOOL)isFacebookLoggedIn {
    return [FBSession activeSession].isOpen;
}

- (void)getFacebookUserDataWithCompletion:(NBSCompletionBlockWithUserData)completion {
    self.userDataCompletion = completion;

    NSDictionary *params = [NSDictionary dictionaryWithObject:@"picture,id,birthday,email,name,gender,username"
                                                       forKey:@"fields"];
    
    [FBRequestConnection startWithGraphPath:@"me"
                                 parameters:params
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            if ([result isKindOfClass:[NSDictionary class]]) {
                NBSUser *user = [NBSUser currentUser];
                user.facebookUid = [result objectForKey:@"id"];
                
                user.facebookAvatarLink = [[[result objectForKey:@"picture"]
                                            objectForKey:@"data"]
                                           objectForKey:@"url"];
                
                NSString *name = [result objectForKey:@"name"];
                if (name.length) {
                    NSArray *nameParts = [name componentsSeparatedByString:@" "];
                    user.facebookFirstName = (nameParts.count > 0) ? [nameParts firstObject] : @"";
                    for (int i = 1; i < nameParts.count; i++) {
                        user.facebookLastName = [NSString stringWithFormat:@"%@%@",
                                                 (i > 1) ? @" " : @"",
                                                 nameParts[i]];
                    }
                }
//                user.facebookFirstName = [result objectForKey:@"first_name"];
//                user.facebookLastName = [result objectForKey:@"last_name"];
                
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

- (void)performSharePhotoFBCompletionWithSuccess:(BOOL)success error:(NSError *)error data:(id)data {
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
                                             } else {
                                                 [self performSharePhotoFBCompletionWithSuccess:NO
                                                                                          error:nil
                                                                                           data:nil];
                                             }
                                         }];
    }else{
        [self postImage:image];
    }
}

- (void)postImage:(UIImage *)image {
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:kNBSSharePhotoPostMessage forKey:@"message"];
    [params setObject:UIImagePNGRepresentation(image) forKey:@"source"];
    [params setValue:@"0" forKey:@"no_store"];
    
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              [self performSharePhotoFBCompletionWithSuccess:(error == nil)
                                                                     error:error
                                                                      data:result];
                          } ];
}

- (void)checkIsMemberOfGroupFBWithCompletion:(NBSCompletionBlockWithData)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[[FBSession activeSession] accessTokenData] accessToken]
               forKey:@"access_token"];
    
    void (^checkMembers)() = ^(){
        [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/members", kNBSFacebookGroupID]
                                     parameters:params
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  NSNumber *resultData = nil;
                                  if (!error) {
                                      NSArray *members = [result objectForKey:@"data"];
                                      for (NSDictionary *member in members) {
                                          if ([[member objectForKey:@"id"] isEqualToString:[[NBSUser currentUser] facebookUid]])
                                          {
                                              resultData = [NSNumber numberWithBool:YES];
                                              break;
                                          }
                                      }
                                  } else {
                                      [UIAlertView showErrorAlertWithError:error];
                                  }
                                  if (completion) {
                                      completion(!error, error, resultData);
                                  }
                              } ];
    };
    
    if ([[[FBSession activeSession]permissions]indexOfObject:@"user_groups"] == NSNotFound) {
        
        [FBSession openActiveSessionWithPublishPermissions:@[@"user_groups, friends_groups"]
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             if (session.isOpen && !error) {
                                                 [FBSession setActiveSession:session];
                                                 checkMembers();
                                             } else {
                                                 if (completion) {
                                                     completion(NO, error, nil);
                                                 }
                                             }
                                         }];
    }else{
        checkMembers();
    }

}

- (void)joinGroupFBWIthCompletion:(NBSCompletionBlock)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[[FBSession activeSession] accessTokenData] accessToken]
               forKey:@"access_token"];
    
    void (^joinGroup)() = ^(){
        NSString *path = [NSString stringWithFormat:@"%@/members/%@", kNBSFacebookGroupID,
                          [NBSUser currentUser].facebookUid];

        [FBRequestConnection startWithGraphPath:path
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (error) {
                                      [UIAlertView showErrorAlertWithError:error];
                                  } else {
                                      [NBSGoogleAnalytics sendEventWithCategory:NBSGAEventCategoryFacebook
                                                                         action:NBSGAEventActionLike];
                                  }
                                  if (completion) {
                                      completion(!error, error);
                                  }
                              }];
    };
    
    if ([[[FBSession activeSession]permissions]indexOfObject:@"user_groups"] == NSNotFound) {
        
        [FBSession openActiveSessionWithPublishPermissions:@[@"user_groups"]
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             if (session.isOpen && !error) {
                                                 [FBSession setActiveSession:session];
                                                 joinGroup();
                                             } else {
                                                 if (completion) {
                                                     completion(NO, error);
                                                 }
                                             }
                                         }];
    }else{
        joinGroup();
    }

}

@end
