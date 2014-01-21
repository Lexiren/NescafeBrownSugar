//
//  NBSMenuViewController.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/6/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSRootViewController.h"
#import "NBSMenuViewController.h"
#import "NBSInstructionsViewController.h"
#import "NBSProfileViewController.h"
#import "NBSNavigationController.h"
#import "UIViewController+NBSNavigationItems.h"

@interface NBSRootViewController ()

@end

@implementation NBSRootViewController

- (void)awakeFromNib
{
    //initial main content - help screen
    self.parallaxEnabled = NO;
    
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:kNBSProfileVCIdentifier];
    NBSNavigationController *navigationViewController = [[NBSNavigationController alloc] initWithRootViewController:viewController];
    [viewController showLeftMenuBarButton:YES];
    self.contentViewController = navigationViewController;
    
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:kNBSMenuVCIdentifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //if it is first app launch - then main contant - help screen else - login screen
    if ([self isNotFirstAppLogin]) {
        [self presentMenuViewController];
    } else {
        UIViewController *helpViewController = [self.storyboard instantiateViewControllerWithIdentifier:kNBSHelpVCIdentifier];
        NBSNavigationController *navigationViewController = [[NBSNavigationController alloc] initWithRootViewController:helpViewController];
        [helpViewController showLeftMenuBarButton:NO];
        [self presentViewController:navigationViewController
                                                  animated:NO
                                                completion:^{
                             
                                                }];
        
        //if it is first app launch - set flag to YES
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNBSNotFirstAppLaunchUserDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (BOOL)isNotFirstAppLogin {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kNBSNotFirstAppLaunchUserDefaultsKey];
}
@end
