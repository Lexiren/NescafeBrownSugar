//
//  NBSSocialManager+Facebook.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/3/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSocialManager.h"

@interface NBSSocialManager (Facebook)

- (void)facebookLoginWithCompletion:(NBSCompletionBlock)completion;
- (BOOL)isFacebookLoggedIn;

- (void)getFacebookUserDataWithCompletion:(NBSCompletionBlockWithUserData)completion;

- (void)postImageToFB:(UIImage*)image withCompletion:(NBSCompletionBlockWithData)completion;

@end
