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
#import "VKRequest.h"
#import "NBSUser.h"
#import "VKAccessToken.h"
#import <AFHTTPRequestOperationManager.h>
#import "NBSGoogleAnalytics.h"

#define kNBSVkontakteAppIDPlistKey @"VkontakteAppID"
#define kNBSVkontakteUserDataRequestSignature @"UserDataRequest"
#define KNBSVkontaktePhotosWallUploadServerRequestSignature @"PhotosWallUploadServerRequest"
#define KNBSVkontaktePhotosWallSaveRequestSignature @"SaveWallPhotosRequest"
#define KNBSVkontakteWallPostRequestSignature @"WallPostRequest"


@implementation NBSSocialManager (Vkontakte)  

- (void)vkontakteLoginWithCompletion:(NBSCompletionBlock)completion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *vkontakteAppID = [infoDictionary objectForKey:kNBSVkontakteAppIDPlistKey];
    VKConnector *vkConnector = [VKConnector sharedInstance];
    [vkConnector startWithAppID:vkontakteAppID permissons:@[@"wall", @"groups", @"photos", @"friends"]];
    vkConnector.delegate = self;
    self.loginCompletion = completion;
}

- (BOOL)isVkontakteLoggedIn {
    return [[VKUser currentUser].accessToken isValid];
}

- (void)getVkontakteUserDataWithCompletion:(NBSCompletionBlockWithUserData)completion {
    self.userDataCompletion = completion;
    VKRequest *request = [VKUser currentUser].info;
    request.signature = kNBSVkontakteUserDataRequestSignature;
    request.offlineMode = YES;
    request.delegate = self;
    [request start];
}

- (void)performSharePhotoVKCompletionWithSuccess:(BOOL)success error:(NSError *)error data:(id)data {
    if (self.sharePhotoVKCompletion) {
        self.sharePhotoVKCompletion(success, error, data);
        self.sharePhotoVKCompletion = nil;
        self.sharePhoto = nil;
    }
}

#pragma mark - photos

- (void)postImageToVK:(UIImage *)image withCompletion:(NBSCompletionBlockWithData)completion {
    self.sharePhotoVKCompletion = completion;
    self.sharePhoto = image;
    [self startRequestServerToUploadPhoto];
}

- (void)startRequestServerToUploadPhoto {
    VKRequest *request = [[VKUser currentUser] photosGetWallUploadServer:@{@"user_id":@([[[VKUser currentUser] accessToken] userID])}];;
    request.signature = KNBSVkontaktePhotosWallUploadServerRequestSignature;
    request.offlineMode = YES;
    request.delegate = self;
    [request start];
}

- (void)startUploadSharePhotoToServer:(NSString *)serverURLString {
    NSDictionary *photoInfo = [self sendPOSTRequest:serverURLString withImageData:UIImageJPEGRepresentation(self.sharePhoto, 1.0f)];
    [self startRequestSaveWallPhotoWithOptions:photoInfo];
}

- (NSDictionary *)sendPOSTRequest:(NSString *)reqURl withImageData:(NSData *)imageData {
    NSLog(@"Sending request: %@", reqURl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    // Устанавливаем метод POST
    [request setHTTPMethod:@"POST"];
    
    // Кодировка UTF-8
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;  boundary=%@", stringBoundary];
    
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"%@",endItemBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Добавляем body к NSMutableRequest
    [request setHTTPBody:body];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dict = nil;
    if(responseData){
        NSError* error;
        dict = [NSJSONSerialization JSONObjectWithData:responseData
                                               options:kNilOptions
                                                 error:&error];
        if (error) {
            [self performSharePhotoVKCompletionWithSuccess:NO error:error data:nil];
        } else {
            // Если есть описание ошибки в ответе
            NSString *errorMsg = [[dict objectForKey:@"error"] objectForKey:@"error_msg"];
            if (errorMsg.length) {
                [self performSharePhotoVKCompletionWithSuccess:NO error:nil data:nil];
                NSLog(@"Server response: %@ \nError: %@", dict, errorMsg);
            }
        }
    }
    return dict;
}

- (void)startRequestSaveWallPhotoWithOptions:(NSDictionary *)options {
    NSMutableDictionary *mutableOptions = [options mutableCopy];
    [mutableOptions setObject:[@([[[VKUser currentUser] accessToken] userID]) stringValue]
                       forKey:@"user_id"];
    
    VKRequest *request = [[VKUser currentUser] photosSaveWallPhoto:mutableOptions];
    request.signature = KNBSVkontaktePhotosWallSaveRequestSignature;
    request.offlineMode = YES;
    request.delegate = self;
    [request start];
}

- (void)startRequestPublishOnTheWallSharedPhotoWithOptions:(NSDictionary *)sharedOptions {
    NSMutableDictionary *publishMutableOptions = [NSMutableDictionary dictionary];
    [publishMutableOptions setValue:[sharedOptions objectForKey:@"owner_id"] forKey:@"owner_id"];
    [publishMutableOptions setValue:[sharedOptions objectForKey:@"id"] forKey:@"attachments"];
    [publishMutableOptions setValue:kNBSSharePhotoPostMessage forKey:@"message"];
    
    VKRequest *request = [[VKUser currentUser] wallPost:publishMutableOptions];
    request.signature = KNBSVkontakteWallPostRequestSignature;
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
            user.vkontakteAvatarLink = [userData objectForKey:@"photo_100"];
            user.vkontakteFirstName = [userData objectForKey:@"first_name"];
            user.vkontakteLastName = [userData objectForKey:@"last_name"];
            user.vkontakteUid = [userData objectForKey:@"uid"];
            [self performUserDataCompletionWithSuccess:YES
                                                 error:nil
                                                  user:user];
        }
    } else if ([request.signature isEqualToString:KNBSVkontaktePhotosWallUploadServerRequestSignature]) {
        response = [response objectForKey:@"response"];
        if ([response isKindOfClass:[NSDictionary class]]) {
            [self startUploadSharePhotoToServer:[response objectForKey:@"upload_url"]];
        }
    } else if ([request.signature isEqualToString:KNBSVkontaktePhotosWallSaveRequestSignature]) {
        response = [[response objectForKey:@"response"] firstObject];
        if ([response isKindOfClass:[NSDictionary class]]) {
            [self startRequestPublishOnTheWallSharedPhotoWithOptions:response];
        }
    } else if ([request.signature isEqualToString:KNBSVkontakteWallPostRequestSignature]) {
        NSLog(@"%@", [response description]);
        [self performSharePhotoVKCompletionWithSuccess:YES error:nil data:response];
    }
}



- (void)     VKRequest:(VKRequest *)request
connectionErrorOccured:(NSError *)error {
    if ([request.signature isEqualToString:kNBSVkontakteUserDataRequestSignature]) {
        [self performUserDataCompletionWithSuccess:NO
                                             error:error
                                              user:nil];
    } else if ([request.signature isEqualToString:KNBSVkontaktePhotosWallUploadServerRequestSignature] ||
               [request.signature isEqualToString:KNBSVkontaktePhotosWallSaveRequestSignature] ||
               [request.signature isEqualToString:KNBSVkontakteWallPostRequestSignature])
    {
        [self performSharePhotoVKCompletionWithSuccess:NO
                                               error:error
                                                data:nil];
    }
}

- (void)  VKRequest:(VKRequest *)request
parsingErrorOccured:(NSError *)error {
    if ([request.signature isEqualToString:kNBSVkontakteUserDataRequestSignature]) {
        [self performUserDataCompletionWithSuccess:NO
                                             error:error
                                              user:nil];
    } else if ([request.signature isEqualToString:KNBSVkontaktePhotosWallUploadServerRequestSignature] ||
               [request.signature isEqualToString:KNBSVkontaktePhotosWallSaveRequestSignature] ||
               [request.signature isEqualToString:KNBSVkontakteWallPostRequestSignature])
    {
        [self performSharePhotoVKCompletionWithSuccess:NO
                                               error:error
                                                data:nil];
    }
}

- (void)   VKRequest:(VKRequest *)request
responseErrorOccured:(id)error {
    if ([request.signature isEqualToString:kNBSVkontakteUserDataRequestSignature]) {
        [self performUserDataCompletionWithSuccess:NO
                                             error:nil
                                              user:nil];
    } else if ([request.signature isEqualToString:KNBSVkontaktePhotosWallUploadServerRequestSignature] ||
               [request.signature isEqualToString:KNBSVkontaktePhotosWallSaveRequestSignature] ||
               [request.signature isEqualToString:KNBSVkontakteWallPostRequestSignature])
    {
        [self performSharePhotoVKCompletionWithSuccess:NO
                                               error:error
                                                data:nil];
    }
    NSLog(@"Error in response from Vkontakte = %@", [error description]);
}

#pragma mark - VKConnectorDelegate methods

- (void)VKConnector:(VKConnector *)connector
  willHideModalView:(KGModal *)view
{
    if (![self isVkontakteLoggedIn]) {
        [self performLoginCompletionWithSuccess:NO error:nil];
    }
}

- (void)VKConnector:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNBSShouldAutologinVKDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [NBSGoogleAnalytics sendEventWithCategory:NBSGAEventCategoryVkontakte
                                       action:NBSGAEventActionLogin];
    
    [self getVkontakteUserDataWithCompletion:^(BOOL success, NSError *error, NBSUser *user) {
        [self performLoginCompletionWithSuccess:success error:error];
    }];
}

- (void)VKConnector:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken {
    [self performLoginCompletionWithSuccess:NO error:nil];
}

- (void)VKConnector:(VKConnector *)connector
connectionErrorOccured:(NSError *)error {
    [self performLoginCompletionWithSuccess:NO error:error];
}

- (void)VKConnector:(VKConnector *)connector
parsingErrorOccured:(NSError *)error {
    [self performLoginCompletionWithSuccess:NO error:error];
}

@end
