//
//  NBSSocialManager.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

@interface NBSSocialManager : NSObject

//init
+ (NBSSocialManager *)sharedManager;

//login
- (void)instagramLoginWithCompletion:(NBSCompletionBlock)completion;


@end
