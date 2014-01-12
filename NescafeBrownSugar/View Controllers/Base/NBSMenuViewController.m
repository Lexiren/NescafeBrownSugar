//
//  NBSMenuViewController.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/6/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSMenuViewController.h"
#import "NBSProfileViewController.h"
#import "NBSImagesCollectionViewController.h"
#import "UIViewController+RESideMenu.h"
#import "RESideMenu.h"
#import "NBSNavigationController.h"
#import "UIViewController+NBSNavigationItems.h"

NSString *const kNBSMenuVCIdentifier = @"MenuVC";

@interface NBSMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation NBSMenuViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Профiль";
            break;
        case 1:
            cell.textLabel.text = @"Намалювати";
            break;
        case 2:
            cell.textLabel.text = @"Про проект";
            break;
        case 3:
            cell.textLabel.text = @"Допомога";
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            NBSProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kNBSProfileVCIdentifier];
            profileVC.loginType = NBSLoginTypeNotLogged;
            viewController = profileVC;
        }
            break;
        case 1:
        {
            NBSImagesCollectionViewController *imagesCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:kNBSImagesCollectionVCIdentifier];
            viewController = imagesCollectionVC;
        }
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
    if (viewController) {
        NBSNavigationController *navigationViewController = [[NBSNavigationController alloc] initWithRootViewController:viewController];
        [viewController showLeftMenuBarButton:YES];
        [self.sideMenuViewController setContentViewController:navigationViewController animated:YES];
        [self.sideMenuViewController hideMenuViewController];

    }

}

@end
