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
#import "NBSLoginViewController.h"

@interface NBSRootViewController ()

@end

@implementation NBSRootViewController

- (void)awakeFromNib
{
    //initial main content - help screen
    NSString *contentIdentifier = kNBSHelpNavigationVCIdentifier;
    
    // !!!: uncomment next code for showing help only on first launch
    
//    //if it is first app launch - then main contant - help screen else - login screen
//    BOOL isNotFirstAppLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kNBSNotFirstAppLaunchUserDefaultsKey];
//    if (isNotFirstAppLogin) contentIdentifier = kNBSLoginNavigationVCIdentifier;
//    else {
//        //if it is first app launch - set flag to YES
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNBSNotFirstAppLaunchUserDefaultsKey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }

    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:contentIdentifier];

    //main menu - menu
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:kNBSMenuVCIdentifier];

}

@end
