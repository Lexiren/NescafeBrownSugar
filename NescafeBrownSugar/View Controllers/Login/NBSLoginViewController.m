//
//  NBSLoginViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSLoginViewController.h"
#import <DMActivityInstagram.h>

@interface NBSLoginViewController ()

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
    
#pragma mark - IBActions
- (IBAction)didPressFacebookButton:(UIButton *)sender {
}

- (IBAction)didPressVkontakteButton:(UIButton *)sender {
}

- (IBAction)didPressInstagramButton:(UIButton *)sender {
    //check for instagram
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if (![[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [UIAlertView showSimpleAlertWithTitle:@"Cannot find instagram app on your device!"
                                      message:@"You need first to install instagram app into your device"];
        return;
    }

// if instagram present
    DMActivityInstagram *instagramActivity = [[DMActivityInstagram alloc] init];
    
    NSString *shareText = @"This is some test tect to share";
    NSURL *shareURL = [NSURL URLWithString:@"instagram://"];
    UIImage *testImage = [UIImage imageNamed:@"test_rabbit.jpg"];
    NSArray *activityItems = @[testImage, shareText, shareURL];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[instagramActivity]];
    [self presentViewController:activityController animated:YES completion:nil];
}
    
- (IBAction)didPressSkipButton:(UIButton *)sender {
}
    
@end
