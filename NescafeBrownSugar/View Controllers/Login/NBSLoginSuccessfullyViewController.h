//
//  NBSLoginSuccessfullyViewController.h
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

typedef enum {
    NBSLoginTypeFacebook,
    NBSLoginTypeVkontakte
} NBSLoginType;

@interface NBSLoginSuccessfullyViewController : UIViewController
@property (nonatomic, assign) NBSLoginType loginType;
@end

extern NSString *const kNBSLoginSuccessfullyVCIdentifier;