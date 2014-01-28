//
//  NBSJoinGroupViewController.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/27/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSJoinGroupViewController.h"
#import "NBSDesignAdditions.h"
#import "NBSProfileViewController.h"
#import "NBSNavigationController.h"
#import "NBSSocialManager+Facebook.h"
#import "NBSSocialManager+Vkontakte.h"

#import "UIViewController+NBSNavigationItems.h"

NSString *const kNBSJoinGroupVCPushSegue = @"JoinGroupVCPushSegue";


@interface NBSJoinGroupViewController ()
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *switchLabel;
@property (nonatomic, weak) IBOutlet UISwitch *joinGroupSwitch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, assign) BOOL shouldShowActivityFB;
@property (nonatomic, assign) BOOL shouldShowActivityVK;

@property (nonatomic, weak) IBOutlet UIButton *okButton;

@end

@implementation NBSJoinGroupViewController

#pragma mark - activity

- (void)startActivityAnimating {
    [self.activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)stopActivityAnimating {
    [self.activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)changeActivityAnimating {
    if (_shouldShowActivityFB || _shouldShowActivityVK) {
        [self startActivityAnimating];
    } else {
        [self stopActivityAnimating];
    }
}

- (void)setShouldShowActivityFB:(BOOL)shouldShowActivityFB {
    _shouldShowActivityFB = shouldShowActivityFB;
    [self changeActivityAnimating];
}

- (void)setShouldShowActivityVK:(BOOL)shouldShowActivityVK {
    _shouldShowActivityVK = shouldShowActivityVK;
    [self changeActivityAnimating];
}

#pragma mark - join

- (void)setDidJoinGroupFB:(BOOL)didJoinGroupFB {
    _didJoinGroupFB = didJoinGroupFB;
    [self tryToMoveToNextScreen];
}

- (void)setDidJoinGroupVK:(BOOL)didJoinGroupVK {
    _didJoinGroupVK = didJoinGroupVK;
    [self tryToMoveToNextScreen];
}

- (void)tryToMoveToNextScreen {
    if (_didJoinGroupFB && _didJoinGroupVK) {
        [self moveToNextScreen];
    }
}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.textView.font = [UIFont standartLightFontWithSize:15.f];
    self.switchLabel.font = [UIFont standartLightFontWithSize:14.f];
    self.okButton.titleLabel.font = [UIFont standartFontWithSize:18.f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showLeftMenuBarButton:YES];
    
}

- (void)moveToNextScreen {
    NBSProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kNBSProfileVCIdentifier];
    [profileVC showLeftMenuBarButton:YES];
    [self.navigationController setViewControllers:@[profileVC] animated:YES];
}

#pragma mark - IBAction

- (IBAction)okButtonPressed:(id)sender {
    
    if (!self.joinGroupSwitch.isOn) {
        [self moveToNextScreen];
        return;
    }
    
    NBSSocialManager *socialManager = [NBSSocialManager sharedManager];
    if ([socialManager isFacebookLoggedIn] && !self.didJoinGroupFB) {
        self.shouldShowActivityFB = YES;
        [socialManager joinGroupFBWIthCompletion:^(BOOL success, NSError *error) {
            self.didJoinGroupFB = YES;
            self.shouldShowActivityFB = NO;
        }];
    }
    
    if ([socialManager isVkontakteLoggedIn] && !self.didJoinGroupVK) {
        self.shouldShowActivityVK = YES;
        [socialManager joinGroupVKWIthCompletion:^(BOOL success, NSError *error) {
            self.didJoinGroupVK = YES;
            self.shouldShowActivityVK = NO;
        }];
    }
    
}




@end
