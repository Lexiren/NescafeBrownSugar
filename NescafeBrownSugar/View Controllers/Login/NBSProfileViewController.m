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

NSString *const kNBSProfileVCIdentifier = @"ProfileVC";
NSString *const kNBSProfileNavigationVCIdentifier = @"RootProfileNavigationVC";

@interface NBSProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet FBProfilePictureView *avatarPictureView;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIView *loginSubview;

@property (weak, nonatomic) IBOutlet UIButton *createPictureButton;
@end

@implementation NBSProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginSubview.hidden = YES;
    [self reloadData];
}

#pragma mark - private functions

- (void)reloadData {
    [self.spinner startAnimating];
    
    NBSSocialManager *sharedManager = [NBSSocialManager sharedManager];
    if ([sharedManager isFacebookLoggedIn]) {
        [sharedManager getFacebookUserDataWithCompletion:
         ^(BOOL success, NSError *error, NBSUser *user)
         {
             [self.spinner stopAnimating];
             if (success) {
                 //TODO: fill own gallery
                 self.nameLabel.text = [self fullNameWithFirstName:user.facebookFirstName
                                                          lastName:user.facebookLastName];
                 self.avatarPictureView.hidden = NO;
                 self.avatarPictureView.profileID = user.facebookUid;
                 self.avatarImageView.hidden = YES;
                 self.loginSubview.hidden = YES;
             } else if (error) {
                 [UIAlertView showErrorAlertWithError:error];
             }
         }];
    } else if ([sharedManager isVkontakteLoggedIn]) {
        [sharedManager getVkontakteUserDataWithCompletion:
         ^(BOOL success, NSError *error, NBSUser *user)
         {
             [self.spinner stopAnimating];
             if (success) {
                 //TODO: fill own gallery
                 self.nameLabel.text = [self fullNameWithFirstName:user.vkontakteFirstName
                                                          lastName:user.vkontakteLastName];
                 NSURL *avatarURL = [NSURL URLWithString:user.vkontakteAvatar];
                 NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
                 self.avatarImageView.hidden = NO;
                 self.avatarImageView.image = [UIImage imageWithData:avatarData];
                 self.avatarPictureView.hidden = YES;
                 self.loginSubview.hidden = YES;
             } else if (error) {
                 [UIAlertView showErrorAlertWithError:error];
             }
         }];
    } else {
        [self.spinner stopAnimating];
        self.nameLabel.text = @"Ви не зареестрованi";
        self.avatarImageView.hidden = NO;
        self.avatarImageView.image = [UIImage imageNamed:@"iconUnregisteredUserpic"];
        self.avatarPictureView.hidden = YES;
        self.loginSubview.hidden = NO;
    }
}

- (NSString *)fullNameWithFirstName:(NSString *)firstName lastName:(NSString *)lastName {
    NSString *result = firstName ?: @"";
    if (lastName.length) {
        result = [result stringByAppendingString:[NSString stringWithFormat:@" %@", lastName]];
    }
    return result;
}

#pragma mark - IBActions

- (IBAction)didPressCreatePictureButton:(UIButton *)sender {
    //push images collections
    [self performSegueWithIdentifier:kNBSPushImageCollectionFromProfileSegueIdentifier sender:self];
}

- (IBAction)didPressFBLoginButton:(id)sender {
    [self.spinner startAnimating];
    [[NBSSocialManager sharedManager] facebookLoginWithCompletion:^(BOOL success, NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self.spinner stopAnimating];
        
        if (success) {
            [self reloadData];
        } else {
            if (error) {
                [UIAlertView showErrorAlertWithError:error];
            } else {
                [UIAlertView showSimpleAlertWithMessage:NSLocalizedString(@"FacebookTokenRenewalFailedMessage", nil)];
            }
        }
    }];

}

- (IBAction)didPressVKLoginButoon:(id)sender {
    self.view.userInteractionEnabled = NO;
    [self.spinner startAnimating];
    [[NBSSocialManager sharedManager] vkontakteLoginWithCompletion:^(BOOL success, NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self.spinner stopAnimating];
        
        if (success) {
            [self reloadData];
        } else {
            if (error) {
                [UIAlertView showErrorAlertWithError:error];
            } else {
                [UIAlertView showSimpleAlertWithMessage:NSLocalizedString(@"VkontakteTokenRenewalFailedMessage", nil)];
            }
        }
    }];
}

@end
