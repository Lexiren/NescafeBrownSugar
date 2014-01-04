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

@interface NBSLoginViewController () <UIDocumentInteractionControllerDelegate>
@property (nonatomic, retain) UIDocumentInteractionController *docInteractionController;
@property (nonatomic, copy) NBSCompletionBlock loginCompletionBlock;
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

- (void)setupCallbackBlocks {
    __weak NBSLoginViewController *weakself = self;
    self.loginCompletionBlock = ^(BOOL success, NSError *error) {
        if (success) {
            if (weakself.presentingViewController) {
                [weakself.presentingViewController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            } else {
                //TODO: perform segue with user info screen
            }
        } else {
            DLog(@"Login Completion Error: %@", error ? error.description : @"No error description");
        }
    };
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //init completion blocks
    [self setupCallbackBlocks];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //hide navigation
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - social maganer getter
- (NBSSocialManager *)socialManager {
    return [NBSSocialManager sharedManager];
}

#pragma mark - IBActions
- (IBAction)didPressFacebookButton:(UIButton *)sender {
}

- (IBAction)didPressVkontakteButton:(UIButton *)sender {
    [[self socialManager] vkontakteLoginWithCompletion:self.loginCompletionBlock];
}
    
- (IBAction)didPressSkipButton:(UIButton *)sender {
    if (!self.presentingViewController) {
        [self performSegueWithIdentifier:@"ImagesCollectionScreenPushSegue" sender:self];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

@end
