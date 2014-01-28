//
//  NBSGalleryDetalViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/28/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

NSString *const kNBSGalleryDetailVCIdentifier = @"galleryDetail";
NSString *const kNBSpresentGalleryDetailSegueIdentifier = @"galleryDetailSegue";

#import "NBSGalleryDetalViewController.h"
#import "NBSGalleryImage.h"
#import "UIViewController+NBSNavigationItems.h"

@interface NBSGalleryDetalViewController ()
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end

@implementation NBSGalleryDetalViewController

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
    [self showLeftMenuBarButton:YES];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.activityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSURL *url = self.image.imageURL;
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [self.activityIndicator stopAnimating];
            self.imageView.image = image;
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapHandler:(id)sender {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
