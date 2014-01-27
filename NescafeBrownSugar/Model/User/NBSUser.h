//
//  NBSUser.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/3/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBSUser : NSObject

@property (nonatomic, strong) NSString *vkontakteUid;
@property (nonatomic, strong) NSString *vkontakteAvatarLink;
@property (nonatomic, strong) NSString *vkontakteFirstName;
@property (nonatomic, strong) NSString *vkontakteLastName;

@property (nonatomic, strong) NSString *facebookUid;
@property (nonatomic, strong) NSString *facebookAvatarLink;
@property (nonatomic, strong) NSString *facebookFirstName;
@property (nonatomic, strong) NSString *facebookLastName;

+ (NBSUser *)currentUser;

- (NSString *)fullVkontakteName;
- (NSString *)fullFacebookName;

@end
