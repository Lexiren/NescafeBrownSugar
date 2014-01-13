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
//#import "NBSImagesCollectionViewController.h"
#import "NBSProfileViewController.h"
#import "RESideMenu.h"
#import "NBSNavigationController.h"

NSString *const kNBSLoginNavigationVCIdentifier = @"RootLoginNavigationVC";
NSString *const kNBSLoginVCIdentifier = @"LoginVC";

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
    
    //hide navigation back button
    [self.navigationItem setHidesBackButton:YES];
}

#pragma mark - IBActions

- (IBAction)didPressFacebookButton:(UIButton *)sender {
    self.view.userInteractionEnabled = NO;
    [self.spinner startAnimating];
    [[NBSSocialManager sharedManager] facebookLoginWithCompletion:^(BOOL success, NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self.spinner stopAnimating];
        
        if (success) {
           [self moveToNextScreen];
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
            [self moveToNextScreen];
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
    [self moveToNextScreen];
}

- (void)moveToNextScreen {
    //TODO: maybe move login type to user?
    NBSProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kNBSProfileVCIdentifier];
    NBSNavigationController *navigationController = [[NBSNavigationController alloc] initWithRootViewController:profileVC];

    [self.sideMenuViewController setContentViewController:navigationController animated:YES];
    [self.sideMenuViewController presentMenuViewController];
}

@end
