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

static NSDictionary *_gallerySourceDictionaries;
static NSArray *_gallerySource;

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
    NBSUser *user = [NBSUser currentUser];
    
    BOOL shouldAutologinFB = [[NSUserDefaults standardUserDefaults] boolForKey:kNBSShouldAutologinFBDefaultsKey];
    BOOL shouldAutologinVK = [[NSUserDefaults standardUserDefaults] boolForKey:kNBSShouldAutologinVKDefaultsKey];
    
    shouldAutologinFB = shouldAutologinFB && ![socialManager isFacebookLoggedIn];
    shouldAutologinVK = shouldAutologinVK && ![[user vkontakteUid] length];
    
    if (shouldAutologinVK) {
        [socialManager cleanAuthDataVK];
    }
//    if (shouldAutologinFB) {
//        [socialManager cleanAuthDataFB];
//    }
    
    void (^performLoginIfNeededVK)(BOOL) = ^(BOOL needed){
        if (needed)
        {
            [weakself startSpinnerAnimating];
            
            [socialManager vkontakteLoginWithCompletion:^(BOOL success, NSError *error) {
                [weakself stopSpinnerAnimating];
                
                if (success) {
                    [weakself reloadData];
                } else {
                    [UIAlertView showErrorAlertWithError:error];
                }
            }];
        }
    };
    
    if (shouldAutologinFB)
    {
        [self startSpinnerAnimating];

        [socialManager facebookAutologinWithCompletion:^(BOOL success, NSError *error) {
            [self stopSpinnerAnimating];
            if (success) {
                [weakself reloadData];
            } else {
                [UIAlertView showErrorAlertWithError:error];
            }
            
            performLoginIfNeededVK(shouldAutologinVK);
        }];
    } else {
        performLoginIfNeededVK(shouldAutologinVK);
    }

    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)updateGalleryIfNeeded {
    NBSSocialManager *socialManager = [NBSSocialManager sharedManager];
    if ([NBSGalleryImage needUpdateGallery] && ([socialManager isVkontakteLoggedIn] || [socialManager isFacebookLoggedIn]))
    {
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
        [NBSGalleryImage setNeedUpdateGallery:NO];
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
    if (!dict || ![dict isKindOfClass:[NSDictionary class]] || ![[dict allKeys] count]) {
        //fool protection
        return;
    }
    
    if (_gallerySourceDictionaries) {
        NSMutableDictionary *newSource = [_gallerySourceDictionaries mutableCopy];
        [newSource addEntriesFromDictionary:dict];
        _gallerySourceDictionaries = newSource;
    } else {
        _gallerySourceDictionaries = dict;
    }
    
    
    NSMutableArray *gallerySourceMutable = [NSMutableArray array];
    for (NSString *key in [_gallerySourceDictionaries allKeys]) {
        NSString *value = [_gallerySourceDictionaries objectForKey:key];
        NBSGalleryImage *galleryImage = [[NBSGalleryImage alloc] initWithId:key
                                                             imageURLString:value];
        [gallerySourceMutable addObject:galleryImage];
    }
    
    _gallerySource = gallerySourceMutable;
    [self reloadData];
    
    if ([_gallerySource count]) {
        self.galleryContainerSubview.hidden = NO;
        self.galleryCollection.hidden = NO;
        self.createPictureButton.hidden = YES;
        [self.galleryCollection reloadData];
    } else {
        self.galleryCollection.hidden = YES;
        self.galleryContainerSubview.hidden = YES;
        self.createPictureButton.hidden = NO;
    }
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
//            [sharedManager cleanAuthDataFB];
            defaultState();
        } else {
            self.nameLabel.text = [user fullFacebookName];
            self.avatarPictureView.hidden = NO;
            self.avatarPictureView.profileID = user.facebookUid;
            self.avatarImageView.hidden = YES;
            self.loginSubview.hidden = YES;
            self.galleryContainerSubview.hidden = NO;
            self.createPictureButton.hidden = _gallerySource.count;
            [self updateGalleryIfNeeded];
        }
    } else if ([sharedManager isVkontakteLoggedIn]) {
        if (!user.vkontakteUid.length) {
            [sharedManager cleanAuthDataVK];
            defaultState();
        } else {
            self.nameLabel.text = [user fullVkontakteName];
            NSURL *avatarURL = [NSURL URLWithString:user.vkontakteAvatarLink];
            NSData *avatarData = [NSData dataWithContentsOfURL:avatarURL];
            self.avatarImageView.hidden = NO;
            self.avatarImageView.image = [UIImage imageWithData:avatarData];
            self.avatarPictureView.hidden = YES;
            self.loginSubview.hidden = YES;
            self.galleryContainerSubview.hidden = NO;
            self.createPictureButton.hidden = _gallerySource.count;
            [self updateGalleryIfNeeded];
        }
    } else {
        defaultState();
    }
}

#pragma mark - IBActions

- (void)startSpinnerAnimating {
    self.loginSubview.userInteractionEnabled = NO;
    [self.spinner startAnimating];
}

- (void)stopSpinnerAnimating {
    self.loginSubview.userInteractionEnabled = YES;
    [self.spinner stopAnimating];
}


- (IBAction)didPressCreatePictureButton:(UIButton *)sender {
    //push images collections
    [self performSegueWithIdentifier:kNBSPushImageCollectionFromProfileSegueIdentifier sender:self];
}

- (IBAction)didPressFBLoginButton:(id)sender {
    [self startSpinnerAnimating];
    [[NBSSocialManager sharedManager] facebookLoginWithCompletion:^(BOOL success, NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self stopSpinnerAnimating];
        
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
    [self startSpinnerAnimating];
    [[NBSSocialManager sharedManager] vkontakteLoginWithCompletion:^(BOOL success, NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self stopSpinnerAnimating];
        
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
    int count = _gallerySource.count;
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
    NBSGalleryImage *image = _gallerySource[indexPath.row];
    
    cell.layer.cornerRadius = 10;
    cell.layer.masksToBounds = YES;
    if (image.preview) {
        cell.imageThumbView.image = image.preview;
    } else {
        UIActivityIndicatorView *spiner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spiner.center = cell.contentView.center;
        [cell.contentView addSubview:spiner];
        [spiner startAnimating];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.previewLink]];
            UIImage *previewImage = [UIImage imageWithData:data];
            
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                [spiner stopAnimating];
                [spiner removeFromSuperview];
                cell.imageThumbView.image = previewImage;
                image.preview = previewImage;
            });
        });
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.selectedImage = _gallerySource[indexPath.row];
    [self performSegueWithIdentifier:kNBSpresentGalleryDetailSegueIdentifier sender:self];
}


@end
