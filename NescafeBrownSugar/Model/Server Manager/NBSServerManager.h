//
//  NBSServerManager.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/24/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NBSTemplate;

#define kNBSServerAPIParameterKeyFBid @"fbid"
#define kNBSServerAPIParameterKeyVKid @"vkid"
#define kNBSServerAPIParameterKeyFBavatar @"fbAvatar"
#define kNBSServerAPIParameterKeyVKavatar @"vkAvatar"
#define kNBSServerAPIParameterKeyFBname @"fbName"
#define kNBSServerAPIParameterKeyVKname @"vkName"
#define kNBSServerAPIParameterKeyPicture @"picture"
#define kNBSServerAPIParameterKeyTemplateID @"templateID"
#define kNBSServerAPIParameterKeyVKpostID @"vkPostID"
#define kNBSServerAPIParameterKeyFBpostID @"fbPostID"

#define kNBSServerURL @"http://brown-sugar.com.ua/app.php"

@interface NBSServerManager : NSObject

+ (NBSServerManager *)sharedManager;

- (void)sendPhoto:(UIImage *)photo
         postInfo:(NSDictionary *)postInfo
       completion:(NBSCompletionBlock)completion;


@end
