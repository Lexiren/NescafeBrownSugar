//
//  NBSGalleryImage.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/28/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSGalleryImage.h"
#import "NBSServerManager.h"
@implementation NBSGalleryImage

- (id)initWithId:(NSString *)imageID image:(UIImage *)image {
    if (self = [super init]) {
        self.imageID = imageID;
        self.imagePreview = image;
    }
    return self;
}

- (NSURL *)imageURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/gallery_show/%@/",kNBSServerURL, self.imageID]];
}

@end
