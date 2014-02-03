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
    
    FBSessionStateHandler sessionStateChangedHandler = ^(FBSession *session, FBSessionState status, NSError *error) {
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
    };

    if (![self isFacebookLoggedIn]) {
        if ([FBSession activeSession].state == FBSessionStateCreated ||
            [FBSession activeSession].state == FBSessionStateCreatedTokenLoaded)
        {
            [[FBSession activeSession] openWithCompletionHandler:sessionStateChangedHandler];
        } else {
            [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                               allowLoginUI:allowLoginUI
                                          completionHandler:sessionStateChangedHandler];
        }
    }
}

- (void)cleanAuthDataFB {
    [[FBSession activeSession] closeAndClearTokenInformation];
}

- (BOOL)isFacebookLoggedIn {
    BOOL isOpenFBSession = [[FBSession activeSession] isOpen];
    return isOpenFBSession;
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
        [FBRequestConnection startWithGraphPath:@"/me/likes"
                                     parameters:params
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  NSNumber *resultData = nil;
                                  if (!error) {
                                      NSArray *pages = [result objectForKey:@"data"];
                                      for (NSDictionary *page in pages) {
                                          if ([[page objectForKey:@"id"] isEqualToString:kNBSFacebookGroupID])
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
    
    if ([[[FBSession activeSession]permissions]indexOfObject:@"user_likes"] == NSNotFound) {
        
        [FBSession openActiveSessionWithPublishPermissions:@[@"user_likes, friends_likes"]
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


- (NSURLRequest *)facebookJoinGroupPluginRequestWithPluginSize:(CGSize)pluginSize {
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = [infoDict objectForKey:@"FacebookAppID"];
    
    NSString *likeButtonIframe = [NSString stringWithFormat:@"http://www.facebook.com/plugins/likebox.php?href=https://www.facebook.com/%@&amp;width=%d&amp;height=%d&amp;colorscheme=light&amp;show_faces=true&amp;header=false&amp;stream=false&amp;show_border=false&amp;appId=%@",kNBSFacebookGroupID,(int)pluginSize.width,(int)pluginSize.height,appID];
    
    NSURLRequest *result = [NSURLRequest requestWithURL:[NSURL URLWithString:likeButtonIframe]];
    return result;
}


@end
