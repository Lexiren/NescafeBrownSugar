//
//  NBSJoinGroupViewController.h
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/27/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBSJoinGroupViewController : NBSViewController

@property (nonatomic, assign) BOOL didJoinGroupFB;
@property (nonatomic, assign) BOOL didJoinGroupVK;

@end

extern NSString *const kNBSJoinGroupVCPushSegue;