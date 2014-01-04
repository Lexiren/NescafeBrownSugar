//
//  NBSUser.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/3/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBSUser : NSObject

+ (NBSUser *)currentUser;
- (BOOL)isLogged;

@end
