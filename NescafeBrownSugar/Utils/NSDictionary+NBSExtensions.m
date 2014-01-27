//
//  NSDictionary+NBSExtensions.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/25/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NSDictionary+NBSExtensions.h"

@implementation NSDictionary (NBSExtensions)

- (void)setValueIfExist:(id)value forKey:(NSString *)key {
    if (value && ![value isKindOfClass:[NSNull class]] && key && [key isKindOfClass:[NSString class]]) {
        [self setValue:value forKey:key];
    }
}

@end
