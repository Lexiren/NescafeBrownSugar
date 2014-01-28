//
//  NBSMainWorkViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSMainWorkViewController.h"
#import "UIView+NIB.h"
#import "NBSTemplateCameraOverlayView.h"
#import "NBSPhotoCameraOverlay.h"
#import "UIViewController+NBSNavigationItems.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NBSSharePreviewController.h"
#import "NBSPhotoPreviewController.h"

NSString *const kNBSPushMainWorkControllerSegueIdentifier = @"MainWorkControllerPushSegue";
NSString *const kNBSPushPhotoMainWorkControllerSegueIdentifier = @"PhotoMainWorkVCPushSegue";

@interface NBSMainWorkViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, assign) BOOL isCameraPresent;

@end

@implementation NBSMainWorkViewController

#pragma mark - init

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.mode = NBSImagePickerModeCameraDrawing;
    }
    return self;
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //do not allow auto lock
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [self showLeftMenuBarButton:YES];
    [self showRightCameraBarButton:(self.mode != NBSImagePickerModePhoto)];
    [self setNavigationType:((self.mode != NBSImagePickerModeWhiteBGDrawing) ? NBSNavigationTypeWhite : NBSNavigationTypeBrown)];

    self.isCameraPresent = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!_isCameraPresent) {
        [UIAlertView showErrorAlertWithMessage:@"This device has no camera"];
    } else {
        self.imagePicker.view.frame = self.view.bounds;
        [self setupImagePickerCameraAndOverlay];
        [self.view addSubview: self.imagePicker.view];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setNavigationType:NBSNavigationTypeWhite];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.imagePicker.delegate = nil;
    self.imagePicker = nil;
    
    //allow auto lock
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)rightCameraButtonDidPress:(UIButton *)sender {
    static CGFloat defaultBrightness = 1.0;
    switch (self.mode) {
        case NBSImagePickerModeCameraDrawing: {
            [self setNavigationType:NBSNavigationTypeBrown];
            self.mode = NBSImagePickerModeWhiteBGDrawing;
            defaultBrightness = [[UIScreen mainScreen] brightness];
            [[UIScreen mainScreen] setBrightness:1.0];
        }
            break;
        case NBSImagePickerModeWhiteBGDrawing: {
            [self setNavigationType:NBSNavigationTypeWhite];
            self.mode = NBSImagePickerModeCameraDrawing;
            [[UIScreen mainScreen] setBrightness:defaultBrightness];
        }
            break;
            
        default:
            break;
    }
    [self setupImagePickerCameraAndOverlay];
}

// Will have no effect in ios6 -- see [-init] for that option
- (BOOL) prefersStatusBarHidden
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShareScreenPushSegue"]) {
        NBSSharePreviewController *controller = (NBSSharePreviewController *)segue.destinationViewController;
        controller.previewImage = self.pickedImage;
    } else if ([segue.identifier isEqualToString:kNBSPushPhotoMainWorkControllerSegueIdentifier]) {
        NBSMainWorkViewController *controller = (NBSMainWorkViewController *)segue.destinationViewController;
        controller.mode = NBSImagePickerModePhoto;
    } else if ([segue.identifier isEqualToString:kNBSPreviewPhotoVCPushSegueIdentifier]) {
        NBSPhotoPreviewController *controller = (NBSPhotoPreviewController *)segue.destinationViewController;
        controller.photo = self.pickedImage;
    }
}

#pragma mark - 
- (void)setupImagePickerCameraAndOverlay {
    UIView *overlayView = nil;

    switch (self.mode) {
        case NBSImagePickerModeCameraDrawing: {
            // scale camera view to fill all screen
            // Device's screen size (ignoring rotation intentionally):
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            
            // iOS is going to calculate a size which constrains the 4:3 aspect ratio to the screen size.
            float cameraAspectRatio = 4.0 / 3.0;
            float imageWidth = floorf(screenSize.width * cameraAspectRatio);
            float scale = ceilf((screenSize.height / imageWidth) * 10.0) / 10.0;
            
            _imagePicker.cameraViewTransform = CGAffineTransformTranslate(CGAffineTransformMakeScale(scale, scale), 0, 64);

            
            overlayView = [self templateCameraOverlayWithFrame:self.imagePicker.view.bounds
                                             cameraDrawingMode:YES
                                                 templateImage:self.sourceImage
                                                    doneAction:@selector(didTapDoneButton:)];
        }
            break;
            
        case NBSImagePickerModeWhiteBGDrawing: {
            overlayView = [self templateCameraOverlayWithFrame:self.imagePicker.view.bounds
                                             cameraDrawingMode:NO
                                                templateImage:self.sourceImage
                                                   doneAction:@selector(didTapDoneButton:)];
        }
            break;
        case NBSImagePickerModePhoto: {
            _imagePicker.cameraViewTransform = CGAffineTransformMakeTranslation(0, 64);
            
            overlayView = [self photoCameraOverlayWithFrame:self.imagePicker.view.bounds
                                             snapshotAction:@selector(didTapShapshotButton:)];
        }
            break;
            
            
        default:
            break;
    }
    self.imagePicker.showsCameraControls = NO;
    self.imagePicker.cameraOverlayView = overlayView;

}

- (UIImagePickerController *)imagePicker {
    if (!_imagePicker && self.isCameraPresent) {
        _imagePicker = [UIImagePickerController new];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = NO;
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.navigationBarHidden = YES;
        _imagePicker.toolbarHidden = YES;
        _imagePicker.mediaTypes = @[ (NSString *) kUTTypeImage];
        
        [self addChildViewController:_imagePicker];
        [_imagePicker didMoveToParentViewController:self];
    }
    return _imagePicker;
}

#pragma mark - overlays
- (UIView *)templateCameraOverlayWithFrame:(CGRect)frame
                         cameraDrawingMode:(BOOL)cameraDrawingMode
                             templateImage:(UIImage *)template
                                doneAction:(SEL)action
{
    NBSTemplateCameraOverlayView *overlay = [NBSTemplateCameraOverlayView loadViewFromNIBWithFrame:frame];
    overlay.templateImageView.image = template;
    if (!cameraDrawingMode) {
        overlay.whiteImageBGView.hidden = NO;
        [overlay.doneButton setImage:[UIImage imageNamed:@"iconDrowFinishedBrown"] forState:UIControlStateNormal];
    }
    [overlay.doneButton addTarget:self
                           action:action
                 forControlEvents:UIControlEventTouchUpInside];
    return overlay;
}

- (UIView *)photoCameraOverlayWithFrame:(CGRect)frame snapshotAction:(SEL)action {
    NBSPhotoCameraOverlay *overlay = [NBSPhotoCameraOverlay loadViewFromNIBWithFrame:frame];
    [overlay.snapshotButton addTarget:self
                               action:action
                     forControlEvents:UIControlEventTouchUpInside];
    return overlay;
}

#pragma mark - IBActions

- (void)didTapDoneButton:(id)sender {
    [self performSegueWithIdentifier:kNBSPushPhotoMainWorkControllerSegueIdentifier sender:self];
}

- (void)didTapShapshotButton:(id)sender {
    [self.imagePicker takePicture];
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSegueWithIdentifier:kNBSPreviewPhotoVCPushSegueIdentifier sender:self];
}


@end
