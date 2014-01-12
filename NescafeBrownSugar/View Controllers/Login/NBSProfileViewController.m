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
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet FBProfilePictureView *avatarPictureView;
@property (weak, nonatomic) IBOutlet UIButton *VKLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *FBLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *createPictureButton;
@end

@implementation NBSProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //hide native navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

#pragma mark - private functions

- (void)reloadData {
    [self.spinner startAnimating];
    
    //TODO: delete this fake
    self.bgImageView.image = [UIImage imageNamed:@"ProfileBG1"];

    self.FBLoginButton.hidden = YES;
    self.VKLoginButton.hidden = YES;
    self.createPictureButton.hidden = NO;// according galary
    
    switch (self.loginType) {
        case NBSLoginTypeNotLogged: {
            [self.spinner stopAnimating];
            //TODO: fill default data
            self.bgImageView.image = [UIImage imageNamed:@"ProfileBG0"];
            self.nameLabel.text = nil;
            self.FBLoginButton.hidden = NO;
            self.VKLoginButton.hidden = NO;
            self.createPictureButton.hidden = YES;
        }
            break;
        case NBSLoginTypeFacebook: {
            [[NBSSocialManager sharedManager] getFacebookUserDataWithCompletion:
             ^(BOOL success, NSError *error, NBSUser *user)
             {
                 [self.spinner stopAnimating];
                 if (success) {
                     //TODO: fill own gallery
                     self.nameLabel.text = [self fullNameWithFirstName:user.facebookFirstName
                                                              lastName:user.facebookLastName];
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
                     //TODO: fill own gallery
                     self.nameLabel.text = [self fullNameWithFirstName:user.vkontakteFirstName
                                                              lastName:user.vkontakteLastName];
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
            self.loginType = NBSLoginTypeFacebook;
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
            self.loginType = NBSLoginTypeVkontakte;
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
