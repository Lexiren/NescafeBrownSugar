//
//  NBSSocialManager.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#define kNBSSharePhotoPostMessage @"#brownsugar"

#define kNBSShouldAutologinFBDefaultsKey @"shouldAutologinFB"
#define kNBSShouldAutologinVKDefaultsKey @"shouldAutologinVK"

@interface NBSSocialManager : NSObject
//init
+ (NBSSocialManager *)sharedManager;

@property (nonatomic, copy) NBSCompletionBlock loginCompletion;
- (void)performLoginCompletionWithSuccess:(BOOL)success
                                    error:(NSError *)error;
@property (nonatomic, copy) NBSCompletionBlockWithUserData userDataCompletion;
- (void)performUserDataCompletionWithSuccess:(BOOL)success
                                       error:(NSError *)error
                                        user:(NBSUser *)user;
@property (nonatomic, copy) NBSCompletionBlockWithData sharePhotoVKCompletion;
@property (nonatomic, copy) NBSCompletionBlockWithData sharePhotoFBCompletion;
@property (nonatomic, strong) UIImage *sharePhoto;

@property (nonatomic, copy) NBSCompletionBlockWithData isGroupMemberVKCompletion;
@property (nonatomic, copy) NBSCompletionBlock joinGroupVKCompletion;


- (void)performIsMemberVKCompletionWithSuccess:(BOOL)success
                                         error:(NSError *)error
                                      response:(NSNumber *)response;

- (void)performJoinGroupVKCompletionWithSuccess:(BOOL)success
                                          error:(NSError *)error;

@end
