//
//  NBSSocialManager+Vkontakte.h
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/3/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSocialManager.h"
#import "VKConnector.h"
#import "VKRequest.h"

@interface NBSSocialManager (Vkontakte) <VKConnectorDelegate, VKRequestDelegate>

- (void)vkontakteLoginWithCompletion:(NBSCompletionBlock)completion;
- (BOOL)isVkontakteLoggedIn;

- (void)getVkontakteUserDataWithCompletion:(NBSCompletionBlockWithUserData)completion;

- (void)postImageToVK:(UIImage *)image withCompletion:(NBSCompletionBlockWithData)completion;

- (void)checkIsMemberOfGroupVKWithCompletion:(NBSCompletionBlockWithData)completion;
- (void)joinGroupVKWIthCompletion:(NBSCompletionBlock)completion;
@end
