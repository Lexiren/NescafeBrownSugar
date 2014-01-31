//
//  NBSGalleryImage.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/28/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBSGalleryImage : NSObject

@property (nonatomic, strong) NSString *imageID;
@property (nonatomic, strong, readonly) NSURL *imageURL;
@property (nonatomic, strong) NSString *previewLink;
@property (nonatomic, strong) UIImage *preview;

- (id)initWithId:(NSString *)imageID imageURLString:(NSString *)imageLink;
+ (BOOL)needUpdateGallery;
+ (void)setNeedUpdateGallery:(BOOL)needUpdateGallery;

@end