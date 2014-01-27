//
//  NBSGalleryDetalViewController.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/28/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NBSGalleryImage;
@interface NBSGalleryDetalViewController : UIViewController

@property (nonatomic, strong) NBSGalleryImage *image;

@end

extern NSString *const kNBSGalleryDetailVCIdentifier;
extern NSString *const kNBSpresentGalleryDetailSegueIdentifier;

