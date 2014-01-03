//
//  NBSLoginViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSLoginViewController.h"
#import "NBSSocialManager.h"

@interface NBSLoginViewController () <UIDocumentInteractionControllerDelegate>
@property (nonatomic, retain) UIDocumentInteractionController *docInteractionController;

@end

@implementation NBSLoginViewController

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
    
    //hide navigation
    [self.navigationController setNavigationBarHidden:YES];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - social maganer getter
- (NBSSocialManager *)socialManager {
    return [NBSSocialManager sharedManager];
}

#pragma mark - IBActions
- (IBAction)didPressFacebookButton:(UIButton *)sender {
}

- (IBAction)didPressVkontakteButton:(UIButton *)sender {
}

- (IBAction)didPressInstagramButton:(UIButton *)sender {
    [UIAlertView showComingSoonAlert];
}
    
- (IBAction)didPressSkipButton:(UIButton *)sender {
}


#pragma mark - move it to Social Manager

- (void)instagramShareImage:(UIImage *)imageToShare {
    //check is instagram instaled
    if (![self isInstagramInstalled]) {
        [UIAlertView showSimpleAlertWithTitle:@"Cannot find instagram app on your device!"
                                      message:@"You need first to install instagram app into your device"];
        return;
    }
    //if installed
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndImageContext();
    
    //path for storing temp image file
    NSString  *imageFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.igo"];
    //delete file if it's already exist
    [[NSFileManager defaultManager] removeItemAtPath:imageFilePath error:nil];
    //write image to file
    [UIImagePNGRepresentation(imageToShare) writeToFile:imageFilePath atomically:YES];
    //file url for temp image
    NSURL *imageFileURL = [NSURL fileURLWithPath:imageFilePath];
    
    //create and setup document interaction controller
    self.docInteractionController = [self setupControllerWithURL:imageFileURL usingDelegate:self];
    //show document interaction controller
    [self.docInteractionController presentOpenInMenuFromRect:rect inView:self.view animated:YES ];
}

- (BOOL)isInstagramInstalled {
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    return [[UIApplication sharedApplication] canOpenURL:instagramURL];
}

- (UIDocumentInteractionController *)setupControllerWithURL:(NSURL *)fileURL
                                              usingDelegate:(id<UIDocumentInteractionControllerDelegate>)interactionDelegate
{
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    interactionController.UTI = @"com.instagram.exclusivegram";

    return interactionController;
}



@end
