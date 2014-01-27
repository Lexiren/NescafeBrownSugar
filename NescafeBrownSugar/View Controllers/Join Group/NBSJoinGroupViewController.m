//
//  NBSJoinGroupViewController.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/27/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSJoinGroupViewController.h"
#import "NBSDesignAdditions.h"

NSString *const kNBSJoinGroupVCPushSegue = @"JoinGroupVCPushSegue";

@interface NBSJoinGroupViewController ()
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *switchLabel;
@property (nonatomic, weak) IBOutlet UISwitch *joinGroupSwitch;
@end

@implementation NBSJoinGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.textView.font = [UIFont standartLightFontWithSize:15.f];
    self.switchLabel.font = [UIFont standartLightFontWithSize:14.f];
}

- (IBAction)okButtonPressed:(id)sender {
}

@end
