//
//  NBSPhotoPreviewController.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/15/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBSPhotoPreviewController : NBSViewController

@property (nonatomic, strong) UIImage *photo;

@end

NSString *const kNBSPreviewPhotoVCPushSegueIdentifier;
