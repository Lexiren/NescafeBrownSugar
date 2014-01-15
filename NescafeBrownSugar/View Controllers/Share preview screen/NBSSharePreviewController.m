//
//  NBSSharePreviewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSharePreviewController.h"
#import "UIViewController+NBSNavigationItems.h"

NSString *const kNBSShareVCPushSegueIdentifier = @"ShareVCPushSegue";

@interface NBSSharePreviewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NBSSharePreviewController

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showLeftMenuBarButton:YES];
    
    self.imageView.image = self.previewImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didTapFacebookShare:(id)sender {
    [UIAlertView showComingSoonAlert];
}

- (IBAction)didTapVkontakteShare:(id)sender {
    [UIAlertView showComingSoonAlert];
}

- (IBAction)didTapInstagramShare:(id)sender {
    [UIAlertView showComingSoonAlert];
}

@end
