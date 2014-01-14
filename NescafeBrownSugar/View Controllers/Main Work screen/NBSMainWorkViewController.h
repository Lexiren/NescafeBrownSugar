//
//  NBSMainWorkViewController.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NBSImagePickerModeWork = 0,
    NBSImagePickerModeDone = 1
} NBSImagePickerMode;

@interface NBSMainWorkViewController : UIViewController

@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, assign) NBSImagePickerMode mode;

@end

extern NSString *const kNBSPushMainWorkControllerSegueIdentifier;
