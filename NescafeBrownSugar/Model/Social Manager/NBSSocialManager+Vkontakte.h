//
//  NBSSocialManager+Vkontakte.h
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/3/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSocialManager.h"
#import "VKConnector.h"

@interface NBSSocialManager (Vkontakte) <VKConnectorDelegate>

- (void)vkontakteLoginWithCompletion:(NBSCompletionBlock)completion;


@end
