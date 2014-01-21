//
//  NBSSharePreviewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSharePreviewController.h"
#import "UIViewController+NBSNavigationItems.h"
#import "NBSSocialManager+Facebook.h"
#import "NBSSocialManager+Vkontakte.h"

NSString *const kNBSShareVCPushSegueIdentifier = @"ShareVCPushSegue";

@interface NBSSharePreviewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *shareFBSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shareVKSwitch;

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
    NBSSocialManager *socialManager = [NBSSocialManager sharedManager];
    self.shareFBSwitch.on = [socialManager isFacebookLoggedIn];
    self.shareVKSwitch.on = [socialManager isVkontakteLoggedIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)didTapOkButton:(id)sender {
    //TODO:Share
}
- (IBAction)didChangeStateShareVKSwitch:(id)sender {
}

- (IBAction)didChangeStateShareFBSwitch:(UISwitch *)sender {
}

@end
