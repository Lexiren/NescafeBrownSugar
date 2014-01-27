//
//  NBSSocialManager.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#define kNBSSharePhotoPostMessage @"#brownsugar"

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

@end
