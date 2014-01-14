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
#import "UIViewController+NBSNavigationItems.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "NBSSharePreviewController.h"

NSString *const kNBSPushMainWorkControllerSegueIdentifier = @"MainWorkControllerPushSegue";

@interface NBSMainWorkViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, assign) BOOL isCameraPresent;

@end

@implementation NBSMainWorkViewController

#pragma mark - init

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        if ( NBS_iOSVersionLessThan(@"7.0") ) self.wantsFullScreenLayout = NO;
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
    
    [self showLeftMenuBarButton:YES];
    
    self.isCameraPresent = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (!_isCameraPresent) {
        [UIAlertView showErrorAlertWithMessage:@"This device has no camera"];
    } else {
        self.imagePicker.view.frame = self.view.bounds;
        [self setImagePickerMode:NBSImagePickerModeWork];
        [self.view addSubview: self.imagePicker.view];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.imagePicker = nil;
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
    }
}

#pragma mark - 

- (void)setImagePickerMode:(NBSImagePickerMode)mode {
    switch (mode) {
        case NBSImagePickerModeWork: {
            self.imagePicker.showsCameraControls = NO;
            self.imagePicker.cameraOverlayView = [self cameraOverlayWithTemplateImage:self.sourceImage
                                                                           doneAction:@selector(didTapDoneButton:)];
        }
            break;
        case NBSImagePickerModeDone: {
            self.imagePicker.cameraOverlayView = nil;
            self.imagePicker.showsCameraControls = YES;
        }
            break;
            
        default:
            break;
    }
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
        
        // scale camera view to fill all screen
        // Device's screen size (ignoring rotation intentionally):
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        // iOS is going to calculate a size which constrains the 4:3 aspect ratio to the screen size.
        float cameraAspectRatio = 4.0 / 3.0;
        float imageWidth = floorf(screenSize.width * cameraAspectRatio);
        float scale = ceilf((screenSize.height / imageWidth) * 10.0) / 10.0;
        
        _imagePicker.cameraViewTransform = CGAffineTransformTranslate(CGAffineTransformMakeScale(scale, scale), 0, 64) ;
        
        [self addChildViewController:_imagePicker];
        [_imagePicker didMoveToParentViewController:self];
    }
    return _imagePicker;
}

- (UIView *)cameraOverlayWithTemplateImage:(UIImage *)template doneAction:(SEL)action {
    NBSTemplateCameraOverlayView *overlay = [NBSTemplateCameraOverlayView loadViewFromNIB];
    overlay.templateImageView.image = template;
    [overlay.doneButton addTarget:self
                           action:action
                 forControlEvents:UIControlEventTouchUpInside];
    return overlay;
}

#pragma mark - IBActions

- (void)didTapDoneButton:(id)sender {
    if (self.isCameraPresent) {
        [self setImagePickerMode:NBSImagePickerModeDone];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self performSegueWithIdentifier:@"ShareScreenPushSegue" sender:self];
}


@end
