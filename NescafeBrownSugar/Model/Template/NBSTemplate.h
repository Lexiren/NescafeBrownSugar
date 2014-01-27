//
//  NBSTemplate.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/13/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBSTemplate : NSObject

@property (nonatomic, readonly) int index;
@property (nonatomic, strong, readonly) UIImage *icon;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, readonly) int templateID;

- (id)initWithIndex:(int)index;
+ (void)setCurrentTemplate:(NBSTemplate *)currentTemplate;
+ (NBSTemplate *)currentTemplate;

@end

extern NSString *const kNBSTemplateImagesBaseName;
extern NSString *const kNBSTemplateIconsBaseName;
extern int       const kNBSTemplateIndexDigitsCount;
extern int       const kNBSTemplatesNumber;
extern int       const kNBSTemplatesFirstNumber;
