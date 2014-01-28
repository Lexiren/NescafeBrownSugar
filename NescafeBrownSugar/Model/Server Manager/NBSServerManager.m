//
//  NBSServerManager.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/24/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSServerManager.h"
#import <AFNetworking.h>
#import "NBSUser.h"
#import "NBSTemplate.h"
#import "NBSSocialManager+Facebook.h"
#import "NBSSocialManager+Vkontakte.h"
#import "NSDictionary+NBSExtensions.h"

/*
 
 "fbid" : число  (optional)   - если есть, значит шаринг через ФБ был !!!:string
 "vkid" : число (optional)   - если есть, значит шаринг через ВК был  !!!:string
 "fbAvatar" : data (optional)  !!!:link
 “vkAvatar" : data (optional)  !!!:link
 “fbName” : string [имя<пробел>фамилия] (optional) - если есть, значит шаринг через ФБ был
 “vkName” : string [имя<пробел>фамилия] (optional) - если есть, значит шаринг через ВК был
 "picture" : data (required)
 "templateID" : число (required)
 "vkPostID" : число (optional)   - если есть, значит шаринг через ВК был
 "fbPostID" :  число (optional)   - если есть, значит шаринг через ФБ был
 "OSType" : "iOS"  (required)  - определенная строка
 
 */

@implementation NBSServerManager

#pragma mark - init
+ (NBSServerManager *)sharedManager {
    static NBSServerManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NBSServerManager new];
    });
    return sharedInstance;
}

- (void)sendPhoto:(UIImage *)photo
         postInfo:(NSDictionary *)postInfo
       completion:(NBSCompletionBlock)completion
{
    NBSUser *user = [NBSUser currentUser];
    NBSTemplate *template = [NBSTemplate currentTemplate];
    
    NSMutableDictionary *parameters = [postInfo mutableCopy];
    [parameters setValueIfExist:@(template.templateID) forKey:kNBSServerAPIParameterKeyTemplateID];
    
    [parameters setValueIfExist:user.vkontakteUid forKey:kNBSServerAPIParameterKeyVKid];
    [parameters setValueIfExist:user.vkontakteAvatarLink forKey:kNBSServerAPIParameterKeyVKavatar];
    [parameters setValueIfExist:[user fullVkontakteName] forKey:kNBSServerAPIParameterKeyVKname];

    [parameters setValueIfExist:user.facebookUid forKey:kNBSServerAPIParameterKeyFBid];
    [parameters setValueIfExist:user.facebookAvatarLink forKey:kNBSServerAPIParameterKeyFBavatar];
    [parameters setValueIfExist:[user fullFacebookName] forKey:kNBSServerAPIParameterKeyFBname];
    
    [parameters setValue:@"iOS" forKey:@"OSType"];
    
    NSLog(@"%@", parameters.description);
    
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager POST:[kNBSServerURL stringByAppendingPathComponent:@"app.php"]
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  DLog(@"photo sent to the server successfull");
                  if (completion) {
                      completion(YES, nil);
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"failed sending photo to the server");
                  if (completion) {
                      completion(NO, error);
                  }
              }];
}


//- (void)loadUserGalleryWithCompletion:(NBSCompletionBlockWithData)completion {
//    
//    void (^loadGalleryForFB)(NSMutableDictionary *, NBSCompletionBlockWithData) = ^(NSMutableDictionary *response, NBSCompletionBlockWithData requestCompletion)
//    {
//        if ([[NBSSocialManager sharedManager] isFacebookLoggedIn]) {
//            [self loadGalleryWithSocialNetworkType:@"fbid"
//                                            userID:[NBSUser currentUser].vkontakteUid
//                                        completion:^(BOOL success, NSError *error, NSDictionary *data) {
//                                            if (success) {
//                                                [response addEntriesFromDictionary:(NSDictionary *)data];
//                                            }
//                                            if (requestCompletion) {
//                                                requestCompletion(success, error, response);
//                                            }
//                                        }];
//        }
//    };
//    
//    if ([[NBSSocialManager sharedManager] isVkontakteLoggedIn]) {
//        [self loadGalleryWithSocialNetworkType:@"vkid"
//                                        userID:[NBSUser currentUser].vkontakteUid
//                                    completion:^(BOOL success, NSError *error, id data)
//        {
//            NSMutableDictionary *response = [data mutableCopy];
//            loadGalleryForFB(response, completion);
//        }];
//    } else {
//        loadGalleryForFB([NSMutableDictionary dictionary], completion);
//    }
//}

- (void)loadGalleryWithSocialNetworkType:(NSString *)snType
                                  userID:(NSString *)userID
                              completion:(NBSCompletionBlockWithData)requestCompletion
{
    if (!userID.length) {
        return;
    }
    AFHTTPRequestOperationManager *httpManager = [AFHTTPRequestOperationManager manager];
    [httpManager POST:[kNBSServerURL stringByAppendingFormat:@"/gallery_get/%@/%@/",snType,userID]
           parameters:@{}
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  DLog(@"get gallary successfull");
                  if (requestCompletion) {
                      requestCompletion(YES, nil, responseObject);
                  }
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  DLog(@"failed loading gallery");
                  if (requestCompletion) {
                      requestCompletion(NO, error, nil);
                  }
              }];

}

@end
