//
//  NBSSocialManager.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSocialManager.h"

@interface NBSSocialManager ()

@end

@implementation NBSSocialManager

#pragma mark - init
+ (NBSSocialManager *)sharedManager {
    static NBSSocialManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NBSSocialManager new];
    });
    return sharedInstance;
}

- (void)performLoginCompletionWithSuccess:(BOOL)success error:(NSError *)error {
    if (self.loginCompletion) {
        self.loginCompletion(success, error);
        self.loginCompletion = nil;
    }
}

- (void)performUserDataCompletionWithSuccess:(BOOL)success
                                       error:(NSError *)error
                                        user:(NBSUser *)user {
    if (self.userDataCompletion) {
        self.userDataCompletion(success, error, user);
        self.userDataCompletion = nil;
    }
}

- (void)performSharePhotoCompletionWithSuccess:(BOOL)success error:(NSError *)error data:(id)data {
    if (self.sharePhotoCompletion) {
        self.sharePhotoCompletion(success, error, data);
        self.sharePhotoCompletion = nil;
        self.sharePhoto = nil;
    }
}
@end
