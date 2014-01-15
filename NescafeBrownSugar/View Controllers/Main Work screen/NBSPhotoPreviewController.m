//
//  NBSPhotoPreviewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/15/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSPhotoPreviewController.h"
#import "NBSSharePreviewController.h"
#import "UIViewController+NBSNavigationItems.h"

#define kNBSButtonBottomSpace4Inch 50
#define kNBSButtonBottomSpace3Inch 30

NSString *const kNBSPreviewPhotoVCPushSegueIdentifier = @"PreviewPhotoVCPushSegue";

@interface NBSPhotoPreviewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsBottomSpaceConstraint;

@end

@implementation NBSPhotoPreviewController

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
    self.buttonsBottomSpaceConstraint.constant = (NBS_IsDeviceScreenSize4Inch) ? kNBSButtonBottomSpace4Inch : kNBSButtonBottomSpace3Inch;
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showLeftMenuBarButton:YES];

    self.photoImageView.image = self.photo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kNBSShareVCPushSegueIdentifier]) {
        NBSSharePreviewController *controller = (NBSSharePreviewController *)segue.destinationViewController;
        controller.previewImage = self.photo;
    }
}

#pragma mark - IBAction
- (IBAction)didTapRetakeButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapConfirmButton:(id)sender {
    [self performSegueWithIdentifier:kNBSShareVCPushSegueIdentifier sender:self];
}


@end
