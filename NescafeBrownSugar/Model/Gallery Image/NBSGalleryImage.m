//
//  NBSGalleryImage.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/28/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

static BOOL _needUpdateGalleryUI = NO;

#import "NBSGalleryImage.h"
#import "NBSServerManager.h"
@implementation NBSGalleryImage

- (id)initWithId:(NSString *)imageID imageURLString:(NSString *)imageLink {
    if (self = [super init]) {
        self.imageID = imageID;
        self.previewLink = imageLink;
    }
    return self;
}

- (NSURL *)imageURL {
    NSString *linkAddress = [NSString stringWithFormat:@"%@/gallery_show/%@/",kNBSServerURL, self.imageID];
    NSError *error = nil;
    NSString *imageLink = [NSString stringWithContentsOfURL:[NSURL URLWithString:linkAddress]
                                                   encoding:NSStringEncodingConversionExternalRepresentation
                                                      error:&error];
    if (error) {
        [UIAlertView showErrorAlertWithError:error];
        return nil;
    }
    imageLink = [imageLink stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    imageLink = [imageLink stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSURL *url = [NSURL URLWithString:imageLink];
    return url;
}

+ (BOOL)needUpdateGallery {
    return _needUpdateGalleryUI;
}

+ (void)setNeedUpdateGallery:(BOOL)needUpdateGallery {
    _needUpdateGalleryUI = needUpdateGallery;
}

@end
