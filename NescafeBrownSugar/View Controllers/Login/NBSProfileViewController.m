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
#import "NBSImagesCollectionContainerViewController.h"
#import "NBSUser.h"
#import <QuartzCore/QuartzCore.h>
#import "NBSDesignAdditions.h"
#import "NBSServerManager.h"
#import "NBSImageCollectionViewCell.h"
#import "NBSGalleryImage.h"
#import "NBSGalleryDetalViewController.h"

NSString *const kNBSProfileVCIdentifier = @"ProfileVC";

@interface NBSProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, weak) IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak) IBOutlet FBProfilePictureView *avatarPictureView;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIView *loginSubview;
@property (nonatomic, strong) IBOutlet UIView *galleryContainerSubview;
@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollection;

@property (weak, nonatomic) IBOutlet UIButton *createPictureButton;
@property (weak, nonatomic) IBOutlet UILabel *enterLabel;

@property (strong, nonatomic) NSDictionary *gallerySourceDictionaries;
@property (strong, nonatomic) NSArray *gallerySource;
@property (strong, nonatomic) NBSGalleryImage *selectedImage;

@property (weak, nonatomic) IBOutlet UILabel *yourImagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *noImagesLabel;

@end

@implementation NBSProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginSubview.hidden = YES;
    [self.avatarImageView makeHalfHeightCornerRadius];
    [self.avatarPictureView makeHalfHeightCornerRadius];
    
    [self.nameLabel replaceFontWithStandartLightFont];
    [self.enterLabel replaceFontWithStandartLightFont];
    [self.yourImagesLabel replaceFontWithStandartLightFont];
    [self.noImagesLabel replaceFontWithStandartLightFont];
    [self.createPictureButton.titleLabel replaceFontWithStandartFont];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak NBSProfileViewController *weakself = self;
    
    NBSSocialManager *socialManager = [NBSSocialManager sharedManager];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kNBSShouldAutologinFBDefaultsKey]/* &&
        ![socialManager isFacebookLoggedIn]*/)
    {
        [socialManager facebookAutologinWithCompletion:^(BOOL success, NSError *error) {
            if (success) {
                [weakself reloadData];
            } else {
                [UIAlertView showErrorAlertWithError:error];
            }
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kNBSShouldAutologinVKDefaultsKey] /*&&
                                                                                                     ![socialManager isVkontakteLoggedIn]*/)
            {
                [socialManager getVkontakteUserDataWithCompletion:^(BOOL success, NSError *error, NBSUser *user) {
                    if (success) {
                        [weakself reloadData];
                    } else {
                        [UIAlertView showErrorAlertWithError:error];
                    }
                }];
            }

        }];
    } else if ([[NSUserDefaults standardUserDefaults] boolForKey:kNBSShouldAutologinVKDefaultsKey] /*&&
                                                                                                        ![socialManager isVkontakteLoggedIn]*/)
    {
        [socialManager getVkontakteUserDataWithCompletion:^(BOOL success, NSError *error, NBSUser *user) {
            if (success) {
                [weakself reloadData];
            } else {
                [UIAlertView showErrorAlertWithError:error];
            }
        }];
    }

    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

    NBSUser *user = [NBSUser currentUser];
    if (user.facebookUid.length) {
        [self.spinner startAnimating];

        [[NBSServerManager sharedManager] loadGalleryWithSocialNetworkType:@"fbid"
                                                                    userID:user.facebookUid
                                                                completion:^(BOOL success, NSError *error, id data) {
                                                                    [self.spinner stopAnimating];
                                                                    if (success) {
                                                                        [self updateGallerySourceByAddingDictionary:data];
                                                                    } else {
                                                                        [UIAlertView showErrorAlertWithError:error];
                                                                    }
                                                                }];
    }
    
    if (user.vkontakteUid.length) {
        [self.spinner startAnimating];

        [[NBSServerManager sharedManager] loadGalleryWithSocialNetworkType:@"vkid"
                                                                    userID:user.vkontakteUid
                                                                completion:^(BOOL success, NSError *error, id data) {
                                                                    [self.spinner stopAnimating];
                                                                    if (success) {
                                                                        [self updateGallerySourceByAddingDictionary:data];
                                                                    } else {
                                                                        [UIAlertView showErrorAlertWithError:error];
                                                                    }
                                                                }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kNBSpresentGalleryDetailSegueIdentifier]) {
        NBSGalleryDetalViewController *galleryContainer = (NBSGalleryDetalViewController *)segue.destinationViewController;
        galleryContainer.image = self.selectedImage;
    }
}

#pragma mark - private functions

- (void)updateGallerySourceByAddingDictionary:(NSDictionary *)dict {
    if (_gallerySourceDictionaries) {
        NSMutableDictionary *newSource = [_gallerySourceDictionaries mutableCopy];
        [newSource addEntriesFromDictionary:dict];
        _gallerySourceDictionaries = newSource;
    } else {
        _gallerySourceDictionaries = dict;
    }
    
    
    NSMutableArray *gallerySourceMutable = [NSMutableArray array];
    for (NSString *key in [_gallerySourceDictionaries allKeys]) {
        NBSGalleryImage *galleryImage = [[NBSGalleryImage alloc] initWithId:key
                                                                      image:[_gallerySourceDictionaries objectForKey:key]];
        [gallerySourceMutable addObject:galleryImage];
    }
    
    self.gallerySource = gallerySourceMutable;
    
    [self.galleryCollection reloadData];
}

- (void)reloadData {

    void (^defaultState)() = ^(){
        self.nameLabel.text = @"Залогінься";
        self.avatarImageView.hidden = NO;
        self.avatarImageView.image = [UIImage imageNamed:@"defaultUserAvatar"];
        self.avatarPictureView.hidden = YES;
        self.loginSubview.hidden = NO;
        self.galleryContainerSubview.hidden = YES;
    };
    
    NBSSocialManager *sharedManager = [NBSSocialManager sharedManager];
    NBSUser *user = [NBSUser currentUser];
    if ([sharedManager isFacebookLoggedIn]) {
        if (!user.facebookUid.length) {
            [self.spinner startAnimating];
            defaultState();
        } else {
            [self.spinner stopAnimating];
            self.nameLabel.text = [user fullFacebookName];
            self.avatarPictureView.hidden = NO;
            self.avatarPictureView.profileID = user.facebookUid;
            self.avatarImageView.hidden = YES;
            self.loginSubview.hidden = YES;
            self.galleryContainerSubview.hidden = NO;
        }
    } else if ([sharedManager isVkontakteLoggedIn]) {
        if (!user.vkontakteUid.length) {
            [self.spinner startAnimating];
            defaultState();
        } else {
            [self.spinner stopAnimating];
            self.nameLabel.text = [user fullVkontakteName];
            NSURL *avatarURL = [NSURL URLWithString:user.vkontakteAvatarLink];
            NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
            self.avatarImageView.hidden = NO;
            self.avatarImageView.image = [UIImage imageWithData:avatarData];
            self.avatarPictureView.hidden = YES;
            self.loginSubview.hidden = YES;
            self.galleryContainerSubview.hidden = NO;
        }
    } else {
        defaultState();
    }
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    int count = self.gallerySource.count;
    self.yourImagesLabel.hidden = (count == 0);
    self.noImagesLabel.hidden = (count != 0);
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ImageCellIdentifier";
    
    NBSImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                                 forIndexPath:indexPath];
    NBSGalleryImage *image = self.gallerySource[indexPath.row];
    cell.imageThumbView.image = image.imagePreview;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.selectedImage = self.gallerySource[indexPath.row];
    [self performSegueWithIdentifier:kNBSpresentGalleryDetailSegueIdentifier sender:self];
}


@end
