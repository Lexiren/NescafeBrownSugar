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
#import "NBSUser.h"
#import <FacebookSDK.h>

#import "UIViewController+NBSNavigationItems.h"

NSString *const kNBSJoinGroupVCPushSegue = @"JoinGroupVCPushSegue";


@interface NBSJoinGroupViewController () <UIWebViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UISwitch *joinGroupSwitch;
@property (weak, nonatomic) IBOutlet UILabel *joinGroupAtributedLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, assign) BOOL shouldShowActivityFB;
@property (nonatomic, assign) BOOL shouldShowActivityVK;

@property (nonatomic, assign) BOOL didJoinGroupFB;
@property (nonatomic, assign) BOOL didJoinGroupVK;

@property (nonatomic, weak) IBOutlet UIButton *okButton;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

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
    [self.textView replaceFontWithStandartLightFont];
    [self.joinGroupAtributedLabel replaceFontWithStandartLightFont];
    [self.okButton.titleLabel replaceFontWithStandartFont];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showLeftMenuBarButton:YES];
    NBSUser *user = [NBSUser currentUser];
    NBSSocialManager *socialManager = [NBSSocialManager sharedManager];

    BOOL needFbJoin = !(user.facebookIsGroupMember || ![socialManager isFacebookLoggedIn]);
    BOOL needVkJoin = !(user.vkontakteIsGroupMember || ![socialManager isVkontakteLoggedIn]);
    
    self.joinGroupSwitch.on = (user.facebookIsGroupMember || user.vkontakteIsGroupMember);
    self.joinGroupSwitch.hidden = (!needFbJoin && !needVkJoin);
    self.joinGroupAtributedLabel.hidden = (!needFbJoin && !needVkJoin);
    
    NSString *groupName = @"";
    
    if (!needFbJoin && needVkJoin)
    {
        groupName = @" у vkontakte";
    }
    if (needFbJoin && !needVkJoin)
    {
        groupName = @" у facebook";
    }
    self.joinGroupAtributedLabel.text = [self.joinGroupAtributedLabel.text stringByAppendingString:groupName];
}

- (void)moveToNextScreen {
    NBSProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kNBSProfileVCIdentifier];
    [profileVC showLeftMenuBarButton:YES];
    [self.navigationController setViewControllers:@[profileVC] animated:YES];
}

#pragma mark - IBAction

- (IBAction)okButtonPressed:(id)sender {
    
    if (!self.joinGroupSwitch.isOn || self.joinGroupSwitch.hidden || self.webView.hidden == NO) {
        [self moveToNextScreen];
        return;
    }
    
    self.didJoinGroupFB = NO;
    self.didJoinGroupVK = NO;
    
    NBSUser *user = [NBSUser currentUser];
    
    NBSSocialManager *socialManager = [NBSSocialManager sharedManager];
    if ([socialManager isFacebookLoggedIn] && !user.facebookIsGroupMember) {
        self.shouldShowActivityFB = YES;
        [self showFacebookLikeWebView];
    } else {
        self.didJoinGroupFB = YES;
    }
    
    if ([socialManager isVkontakteLoggedIn] && !user.vkontakteIsGroupMember) {
        self.shouldShowActivityVK = YES;
        [socialManager joinGroupVKWIthCompletion:^(BOOL success, NSError *error) {
            self.didJoinGroupVK = YES;
            self.shouldShowActivityVK = NO;
        }];
    } else {
        self.didJoinGroupVK = YES;
    }
    
}


- (void)showFacebookLikeWebView {
    self.webView.hidden = NO;
    NBSSocialManager *socialManager = [NBSSocialManager sharedManager];
    [self.webView loadRequest:[socialManager facebookJoinGroupPluginRequestWithPluginSize:CGSizeZero]];
}

- (void)hideFacebookLikeWebView {
    self.webView.hidden = YES;
}

- (void)dealloc {
    self.webView.delegate = nil;
}

#pragma  mark - UIWebViewDelegate 

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    DLog(@"REQ: %@\n\n", request.URL.absoluteString);

    NSString *requestLink = request.URL.absoluteString;
    if ([requestLink rangeOfString:@"likebox.php"].location == NSNotFound) {
        return NO;
    }
    
    self.shouldShowActivityFB = YES;
    self.okButton.userInteractionEnabled = NO;
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
        self.shouldShowActivityFB = NO;
        self.okButton.userInteractionEnabled = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
        self.shouldShowActivityFB = NO;
        self.okButton.userInteractionEnabled = YES;
}

@end
