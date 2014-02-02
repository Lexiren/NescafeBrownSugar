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
#import "UIView+NBSExtensions.h"
#import "UIImage+NBSExtensions.h"
#import "NBSDesignAdditions.h"

#define kNBSButtonBottomSpace4Inch 50
#define kNBSButtonBottomSpace3Inch 30
#define kNBSPhotoImageViewHeight4Inch 425
#define kNBSPhotoImageViewHeight3Inch 400
#define kNBSPhotoImageViewWidth 320

NSString *const kNBSPreviewPhotoVCPushSegueIdentifier = @"PreviewPhotoVCPushSegue";

@interface NBSPhotoPreviewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsBottomSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *visiblePartMask;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *retakeButton;
@property (nonatomic, strong) UIImage *imageToShare;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoImageViewTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoImageViewHorizontalCenterConstraint;

@end

@implementation NBSPhotoPreviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buttonsBottomSpaceConstraint.constant = (NBS_IsDeviceScreenSize4Inch) ? kNBSButtonBottomSpace4Inch : kNBSButtonBottomSpace3Inch;
//    self.photoImageViewHeightConstraint.constant = (NBS_IsDeviceScreenSize4Inch) ? kNBSPhotoImageViewHeight4Inch : kNBSPhotoImageViewHeight3Inch;
    
    [self.continueButton.titleLabel replaceFontWithStandartFont];
    [self.retakeButton.titleLabel replaceFontWithStandartFont];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showLeftMenuBarButton:YES];

    [self setupPhotoImageViewSizes];
    self.photoImageView.image = self.photo;
}

- (void)setupPhotoImageViewSizes {
    if (self.photo) {
        BOOL isLandscapePhoto = (self.photo.size.width > self.photo.size.height);
        CGFloat maxWH = MAX(self.photoImageView.frame.size.width, self.photoImageView.frame.size.height);
        CGFloat minWH = MIN(self.photoImageView.frame.size.width, self.photoImageView.frame.size.height);
        
        self.photoImageViewHeightConstraint.constant = (isLandscapePhoto) ? minWH : maxWH;
        self.photoImageViewWidthConstraint.constant = (isLandscapePhoto) ? maxWH : minWH;
        CGFloat k = 0.0;
        
        if (isLandscapePhoto) {
            k = (NBS_isIPad) ? -85 : 10;
            self.photoImageViewHorizontalCenterConstraint.constant = (NBS_isIPad) ? -100.0 : 10;
        }
        
        self.photoImageViewTopSpaceConstraint.constant = (maxWH - self.photoImageViewHeightConstraint.constant)/2.0 + k;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kNBSShareVCPushSegueIdentifier]) {
        NBSSharePreviewController *controller = (NBSSharePreviewController *)segue.destinationViewController;
        controller.previewImage = self.imageToShare;
    }
}

- (void)prepareForSharingImage {
    UIImage *snapshot = [self.photoImageView NBS_makeSnapshot];
    CGRect visibleRect = [self.photoImageView convertRect:self.visiblePartMask.frame
                                                 fromView:self.visiblePartMask.superview];
    
//    CGFloat scale = self.photo.size.width / self.photoImageView.frame.size.width;
//    CGRect rect = visibleRect;
//    rect.origin.x = (rect.origin.x - self.photoImageView.frame.origin.x) * scale;
//    rect.origin.y = (rect.origin.y - self.photoImageView.frame.origin.y) * scale;
//    rect.size.width *= scale;
//    rect.size.height *= scale;
//    
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef c = UIGraphicsGetCurrentContext();
//    CGContextClipToRect(c, CGRectMake(0, 0, rect.size.width, rect.size.height));
//    [self.photoImageView drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.photoImageView.bounds.size.width, self.photoImageView.bounds.size.height)];
//    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    self.imageToShare = result;
    self.imageToShare = [snapshot NBS_cropFromRect:visibleRect];
}

#pragma mark - IBAction
- (IBAction)didTapRetakeButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didTapConfirmButton:(id)sender {
    [self prepareForSharingImage];
    [self performSegueWithIdentifier:kNBSShareVCPushSegueIdentifier sender:self];
}


@end
