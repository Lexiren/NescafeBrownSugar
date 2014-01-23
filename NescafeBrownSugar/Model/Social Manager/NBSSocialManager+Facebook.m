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

- (void)postImageToFB:(UIImage *)image withCompletion:(NBSCompletionBlock)completion {
    if (completion) {
        completion(YES, nil);
    }
//
//    NSString *strMessage = @"This is the photo caption";
//    NSMutableDictionary* photosParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                         image,@"source",
//                                         strMessage,@"message",
//                                         nil];
//    
//    [FBRequestConnection startForUploadPhoto:image
//                           completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                               
//                           }];
}

//- (void)request:(FBRequest *)request didLoad:(id)result {

    
    /*
    // We're going to assume you have a UIImage named image_ stored somewhere.
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    // First request uploads the photo.
    FBRequest *request1 = [FBRequest
                           requestForUploadPhoto:image];
    [connection addRequest:request1
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                 if (error && completion) {
                                     completion(NO, error);
                                 }
                             }
            batchEntryName:@"photopost"
     ];

    FBRequest *request2 = [FBRequest
                           requestForGraphPath:@"{result=photopost:$.id}"];
    [connection addRequest:request2
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             if (!error && result) {
                 NSString *ID = [result objectForKey:@"id"];
                 [self postDataWithPhoto:ID withCompletion:completion];
             } else {
                 if (completion) {
                     completion(NO, error);
                 }
             }
         }
     ];
    
    [connection start];
}

-(void)postDataWithPhoto:(NSString*)photoID withCompletion:(NBSCompletionBlock)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"test image post on my wall" forKey:@"message"];
    
    if(photoID) {
        NSString *urlString = [NSString stringWithFormat:
                               @"https://graph.facebook.com/%@?access_token=%@", photoID,
                               [[[[FBSession activeSession] accessTokenData] accessToken] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [params setObject:urlString forKey:@"picture"];
    }
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
    {
        if (completion) {
            completion((error == nil), error);
        }
    }];
}*/

@end
