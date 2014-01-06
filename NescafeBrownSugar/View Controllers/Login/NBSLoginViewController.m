//
//  NBSLoginViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSLoginViewController.h"
#import "NBSSocialManager.h"
#import "NBSSocialManager+Vkontakte.h"
#import "NBSSocialManager+Facebook.h"
#import "NBSImagesCollectionViewController.h"
#import "NBSProfileViewController.h"

@interface NBSLoginViewController ()
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@end

@implementation NBSLoginViewController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //hide navigation
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - IBActions

- (IBAction)didPressFacebookButton:(UIButton *)sender {
    self.view.userInteractionEnabled = NO;
    [self.spinner startAnimating];
    [[NBSSocialManager sharedManager] facebookLoginWithCompletion:^(BOOL success, NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self.spinner stopAnimating];
        
        if (success) {
            NBSProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:kNBSLoginSuccessfullyVCIdentifier];
            controller.loginType = NBSLoginTypeFacebook;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            if (error) {
                [UIAlertView showErrorAlertWithError:error];
            } else {
                [UIAlertView showSimpleAlertWithMessage:NSLocalizedString(@"FacebookTokenRenewalFailedMessage", nil)];
            }
        }
    }];
}

- (IBAction)didPressVkontakteButton:(UIButton *)sender {
    self.view.userInteractionEnabled = NO;
    [self.spinner startAnimating];
    [[NBSSocialManager sharedManager] vkontakteLoginWithCompletion:^(BOOL success, NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self.spinner stopAnimating];
        
        if (success) {
            NBSProfileViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:kNBSLoginSuccessfullyVCIdentifier];
            controller.loginType = NBSLoginTypeVkontakte;
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            if (error) {
                [UIAlertView showErrorAlertWithError:error];
            } else {
                [UIAlertView showSimpleAlertWithMessage:NSLocalizedString(@"VkontakteTokenRenewalFailedMessage", nil)];
            }
        }
    }];
}
    
- (IBAction)didPressSkipButton:(UIButton *)sender {
    if (!self.presentingViewController) {
        [self performSegueWithIdentifier:kNBSImagesCollectionVCPushSegue sender:self];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
