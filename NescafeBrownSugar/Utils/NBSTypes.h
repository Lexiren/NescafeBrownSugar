//
//  NBSTypes.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#ifndef NescafeBrownSugar_NBSTypes_h
#define NescafeBrownSugar_NBSTypes_h

@class NBSUser;

typedef void (^NBSCompletionBlockWithData)(BOOL success, NSError *error, id data);
typedef void (^NBSCompletionBlock)(BOOL success, NSError *error);
typedef void (^NBSSuccessCompletionBlock)();
typedef void (^NBSSuccessWithDataCompletionBlock)(id data);
typedef void (^NBSFailureCompletionBlock)(NSError *error);
typedef void (^NBSButtonTapHandlerBlock)(UIButton *sender);

typedef void (^NBSCompletionBlockWithUserData)(BOOL success, NSError *error, NBSUser *user);

#endif
