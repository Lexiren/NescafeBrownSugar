//
//  NBSViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 2/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSViewController.h"

#define kNBSNavigationPlaceholderHeightIOS6 44
#define kNBSNavigationPlaceholderHeightIOS7 64

@interface NBSViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationPlaceholderHeightConstraint;
@end

@implementation NBSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (NBS_iOSVersionLessThan(@"7.0")) {
        self.navigationPlaceholderHeightConstraint.constant = kNBSNavigationPlaceholderHeightIOS6;
    } else {
        self.navigationPlaceholderHeightConstraint.constant = kNBSNavigationPlaceholderHeightIOS7;
    }
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
