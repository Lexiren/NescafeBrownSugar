//
//  NBSTemplate.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/13/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSTemplate.h"

NSString *const kNBSTemplateImagesBaseName = @"image_";
NSString *const kNBSTemplateIconsBaseName = @"icon_";
int       const kNBSTemplateIndexDigitsCount = 2;
int       const kNBSTemplatesNumber = 50;
int       const kNBSTemplatesFirstNumber = 1;

static NBSTemplate *_currentInstance;

@implementation NBSTemplate

#pragma mark - public
- (id)init {
    [self doesNotRecognizeSelector:_cmd]; //deny init without index, 'cause index - readonly
    return nil;
}

- (id)initWithIndex:(int)index {
    if (self = [self initPrivate]) {
        if (index < 0 || index > kNBSTemplatesNumber) {
            return nil;
        }
        _index = index;
    }
    return self;
}

- (UIImage *)icon {
    NSString *iconName = [self iconNameForTemplateWithIndex:self.index];
    return [UIImage imageNamed:iconName];
}

- (UIImage *)image {
    NSString *imageName = [self imageNameForTemplateWithIndex:self.index];
    return [UIImage imageNamed:imageName];
}

+ (void)setCurrentTemplate:(NBSTemplate *)currentTemplate {
    _currentInstance = currentTemplate;
}

+ (NBSTemplate *)currentTemplate {
    return _currentInstance;
}

#pragma mark - private
- (id)initPrivate {
    if (self = [super init]) {
        //possible default initialization
    }
    return self;
}

- (NSString *)iconNameForTemplateWithIndex:(int)index {
    return [self imageNameForImageWithBaseName:kNBSTemplateIconsBaseName
                                     indexDigitsCount:kNBSTemplateIndexDigitsCount
                                                index:index];
}

- (NSString *)imageNameForTemplateWithIndex:(int)index {
    return [self imageNameForImageWithBaseName:kNBSTemplateImagesBaseName
                                     indexDigitsCount:kNBSTemplateIndexDigitsCount
                                                index:index];
}

- (NSString *)imageNameForImageWithBaseName:(NSString *)baseName
                           indexDigitsCount:(int)digitsCount
                                      index:(int)index
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    formatter.minimumIntegerDigits = digitsCount;
    NSString *number = [formatter stringFromNumber:@(index + kNBSTemplatesFirstNumber)];
    NSString *imageName = [baseName stringByAppendingString:number];
    
    return imageName;
}

@end
