//
//  NBSLoginSuccessfullyViewController.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSProfileViewController.h"
#import "NBSSocialManager.h"
#import "NBSSocialManager+Facebook.h"
#import "NBSSocialManager+Vkontakte.h"
#import "FBProfilePictureView.h"
#import "NBSImagesCollectionViewController.h"
#import "NBSUser.h"

NSString *const kNBSLoginSuccessfullyVCIdentifier = @"LoginSuccessfullyVC";

@interface NBSProfileViewController ()
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UILabel *firstNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet FBProfilePictureView *avatarPictureView;
@end

@implementation NBSProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.spinner startAnimating];
    switch (self.loginType) {
        case NBSLoginTypeFacebook: {
            [[NBSSocialManager sharedManager] getFacebookUserDataWithCompletion:
             ^(BOOL success, NSError *error, NBSUser *user)
            {
                [self.spinner stopAnimating];
                if (success) {
                    self.firstNameLabel.text = user.facebookFirstName;
                    self.lastNameLabel.text = user.facebookLastName;
                    self.avatarPictureView.profileID = user.facebookUid;
                } else if (error) {
                    [UIAlertView showErrorAlertWithError:error];
                }
            }];
        }
            break;
        case NBSLoginTypeVkontakte: {
            [[NBSSocialManager sharedManager] getVkontakteUserDataWithCompletion:
             ^(BOOL success, NSError *error, NBSUser *user)
            {
                [self.spinner stopAnimating];
                if (success) {
                    self.firstNameLabel.text = user.vkontakteFirstName;
                    self.lastNameLabel.text = user.vkontakteLastName;
                    NSURL *avatarURL = [NSURL URLWithString:user.vkontakteAvatar];
                    NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
                    self.avatarImageView.image = [UIImage imageWithData:avatarData];
                } else if (error) {
                    [UIAlertView showErrorAlertWithError:error];
                }
            }];
        }
            break;

    }
}

- (IBAction)didPressSkipButton:(UIButton *)sender {
    if (!self.presentingViewController) {
        [self performSegueWithIdentifier:kNBSImagesCollectionVCPushSegue sender:self];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
