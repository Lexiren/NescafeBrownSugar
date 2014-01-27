//
//  NBSSharePreviewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSSharePreviewController.h"
#import "UIImage+NBSExtensions.h"
#import "UIViewController+NBSNavigationItems.h"
#import "NBSSocialManager+Facebook.h"
#import "NBSSocialManager+Vkontakte.h"
#import "NBSServerManager.h"
#import <Social/Social.h>
#import "NBSJoinGroupViewController.h"
#import "NBSGoogleAnalytics.h"

NSString *const kNBSShareVCPushSegueIdentifier = @"ShareVCPushSegue";

@interface NBSSharePreviewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *shareFBSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shareVKSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL animateActivityForFB;
@property (assign, nonatomic) BOOL animateActivityForVK;

//data for sending photo to server
// if postInfo == nil - there wansn't posting to this social network
// if postInfo empty - photo is still posting to social network at this moment
@property (assign, nonatomic) BOOL animateActivityForServer;
@property (assign, nonatomic) BOOL didPostPhotoToFB;
@property (assign, nonatomic) BOOL didPostPhotoToVK;
@property (strong, nonatomic) NSDictionary *fbPostInfo;
@property (strong, nonatomic) NSDictionary *vkPostInfo;
@property (strong, nonatomic) UIImage *photoToSend;

@end

@implementation NBSSharePreviewController

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showLeftMenuBarButton:YES];
    
    self.imageView.image = self.previewImage;
    NBSSocialManager *socialManager = [NBSSocialManager sharedManager];
    self.shareFBSwitch.on = [socialManager isFacebookLoggedIn];
    self.shareVKSwitch.on = [socialManager isVkontakteLoggedIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - activity indicator
- (void)changeActivityIndicatorAnimating {
    if (self.animateActivityForFB || self.animateActivityForVK || self.animateActivityForServer) {
        self.view.userInteractionEnabled = NO;
        [self.activityIndicator startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else {
        self.view.userInteractionEnabled = YES;
        [self.activityIndicator stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}

- (void)setAnimateActivityForFB:(BOOL)animateActivityForFB {
    _animateActivityForFB = animateActivityForFB;
    [self changeActivityIndicatorAnimating];
}

- (void)setAnimateActivityForVK:(BOOL)animateActivityForVK {
    _animateActivityForVK = animateActivityForVK;
    [self changeActivityIndicatorAnimating];
}

- (void)setDidPostPhotoToFB:(BOOL)didPostPhotoToFB {
    _didPostPhotoToFB = didPostPhotoToFB;
    if (didPostPhotoToFB) {
        [self tryToSendPhotoWithPostInfoToServer];
    }
}

- (void)setDidPostPhotoToVK:(BOOL)didPostPhotoToVK {
    _didPostPhotoToVK = didPostPhotoToVK;
    if (didPostPhotoToVK) {
        [self tryToSendPhotoWithPostInfoToServer];
    }
}

- (void)setAnimateActivityForServer:(BOOL)animateActivityForServer {
    _animateActivityForServer = animateActivityForServer;
    [self changeActivityIndicatorAnimating];
}

- (void)tryToSendPhotoWithPostInfoToServer {
    if (_didPostPhotoToVK && _didPostPhotoToFB) {
        NSMutableDictionary *postInfo = [NSMutableDictionary dictionary];
        if (self.fbPostInfo) {
            [postInfo addEntriesFromDictionary:self.fbPostInfo];
        }
        if (self.vkPostInfo) {
            [postInfo addEntriesFromDictionary:self.vkPostInfo];
        }
        self.animateActivityForServer = YES;
        [[NBSServerManager sharedManager] sendPhoto:self.photoToSend
                                           postInfo:postInfo
                                         completion:^(BOOL success, NSError *error) {
                                             self.animateActivityForServer = NO;
                                             if (success) {
                                             } else {
                                                 [UIAlertView showErrorAlertWithError:error];
                                             }
                                             [self performSegueWithIdentifier:kNBSJoinGroupVCPushSegue
                                                                       sender:self];
                                         }];
    }
}

#pragma mark - IBActions
- (IBAction)didTapOkButton:(id)sender {
    self.fbPostInfo = nil;
    self.vkPostInfo = nil;
    self.didPostPhotoToFB = NO;
    self.didPostPhotoToVK = NO;
    
    NBSSocialManager *socialManager = [NBSSocialManager sharedManager];
    UIImage *photoBound = [UIImage imageNamed:@"fotoFrame"];
    UIImage *photoWithBound = [self.previewImage NBS_mergeWithImage:photoBound finalSize:photoBound.size];
    self.photoToSend = photoWithBound;
    
    if (self.shareFBSwitch.isOn) {
        self.didPostPhotoToFB = NO;
        self.animateActivityForFB = YES;
        
        void (^postToFB)() = ^(){
            [socialManager postImageToFB:photoWithBound withCompletion:^(BOOL success, NSError *error, id data) {
                self.animateActivityForFB = NO;
                if (!success) {
                    [UIAlertView showErrorAlertWithError:error];
                } else {
//                    [UIAlertView showSimpleAlertWithMessage:@"Фото успiшно розмiщене у Facebook"];
                    id post_id = [data objectForKey:@"post_id"];
                    if (![post_id isKindOfClass:[NSString class]]) {
                        post_id = [post_id stringValue];
                    }
                    self.fbPostInfo = @{kNBSServerAPIParameterKeyFBpostID: post_id};
                    [NBSGoogleAnalytics sendEventWithCategory:NBSGAEventCategoryFacebook
                                                       action:NBSGAEventActionShare];
                }
                self.didPostPhotoToFB = YES;
            }];
        };
        
        if ([socialManager isFacebookLoggedIn]) {
            postToFB();
        } else {
            [socialManager facebookLoginWithCompletion:^(BOOL success, NSError *error) {
                self.animateActivityForFB = NO;
                if (success) {
                    self.animateActivityForFB = YES;
                    postToFB();
                } else {
                    self.didPostPhotoToFB = YES;
                    [UIAlertView showErrorAlertWithError:error];
                }
            }];
        }
    } else {
        self.didPostPhotoToFB = YES;
    }
    if (self.shareVKSwitch.isOn) {
        self.didPostPhotoToVK = NO;
        self.animateActivityForVK = YES;
        self.vkPostInfo = [NSMutableDictionary dictionary];
        
        void (^postToVK)() = ^(){
            [socialManager postImageToVK:photoWithBound withCompletion:^(BOOL success, NSError *error, id data) {
                self.animateActivityForVK = NO;
                if (!success) {
                    [UIAlertView showErrorAlertWithError:error];
                } else {
//                    [UIAlertView showSimpleAlertWithMessage:@"Фото успiшно розмiщене у Vkontakte"];
                    id post_id = [[data objectForKey:@"response"] objectForKey:@"post_id"];
                    if (![post_id isKindOfClass:[NSString class]]) {
                        post_id = [post_id stringValue];
                    }
                    self.vkPostInfo = @{kNBSServerAPIParameterKeyVKpostID : post_id};

                    [NBSGoogleAnalytics sendEventWithCategory:NBSGAEventCategoryVkontakte
                                                       action:NBSGAEventActionShare];
                    
                }
                self.didPostPhotoToVK = YES;
            }];
        };
        
        if ([socialManager isVkontakteLoggedIn]) {
            postToVK();
        } else {
            [socialManager vkontakteLoginWithCompletion:^(BOOL success, NSError *error) {
                self.animateActivityForVK = NO;
                if (success) {
                    self.animateActivityForVK = YES;
                    postToVK();
                } else {
                    [UIAlertView showErrorAlertWithError:error];
                    self.didPostPhotoToVK = YES;
                }
            }];
        }
    } else {
        self.didPostPhotoToVK = YES;
    }
}

- (IBAction)didChangeStateShareVKSwitch:(id)sender {
}

- (IBAction)didChangeStateShareFBSwitch:(UISwitch *)sender {
}

@end
