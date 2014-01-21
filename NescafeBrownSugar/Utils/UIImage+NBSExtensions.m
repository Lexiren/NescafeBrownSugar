//
//  UIImage+NBSExtensions.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/20/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "UIImage+NBSExtensions.h"

@implementation UIImage (NBSExtensions)

-(UIImage*)NBS_cropFromRect:(CGRect)fromRect
{
    fromRect = CGRectMake(fromRect.origin.x * self.scale,
                          fromRect.origin.y * self.scale,
                          fromRect.size.width * self.scale,
                          fromRect.size.height * self.scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, fromRect);
    UIImage* crop = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return crop;
}

@end
