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
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *imagePreview;

- (id)initWithId:(NSString *)imageID image:(UIImage *)image;

@end