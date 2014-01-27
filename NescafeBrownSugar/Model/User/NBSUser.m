//
//  NBSUser.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/3/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSUser.h"

@implementation NBSUser

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initPrivate {
    if (self = [super init]) {
        //do nothing
        //possibly need autosetup from user defaults etc.
    }
    return self;
}

+ (NBSUser *)currentUser {
    static NBSUser *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NBSUser alloc] initPrivate];
    });
    return sharedInstance;
}

- (NSString *)fullVkontakteName {
    return [self fullNameWithFirstName:self.vkontakteFirstName lastName:self.vkontakteLastName];
}

- (NSString *)fullFacebookName {
    return [self fullNameWithFirstName:self.facebookFirstName lastName:self.facebookLastName];
}

- (NSString *)fullNameWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    NSString *result = firstName ?: @"";
    if (lastName.length) {
        result = [result stringByAppendingString:[NSString stringWithFormat:@" %@", lastName]];
    }
    return result;
}
@end
