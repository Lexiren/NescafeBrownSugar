//
//  NBSSocialManager.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSocialManager.h"

@interface NBSSocialManager ()

@end

@implementation NBSSocialManager

#pragma mark - init
+ (NBSSocialManager *)sharedManager {
    static NBSSocialManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NBSSocialManager new];
    });
    return sharedInstance;
}

@end
