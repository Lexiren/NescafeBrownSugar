//
//  NSDictionary+NBSExtensions.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/25/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NBSExtensions)

- (void)setValueIfExist:(id)value forKey:(NSString *)key;

@end
