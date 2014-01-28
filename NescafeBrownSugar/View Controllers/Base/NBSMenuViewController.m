//
//  NBSMenuViewController.m
//  NescafeBrownSugar
//
//  Created by Irina Vasilyeva on 1/6/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSMenuViewController.h"
#import "NBSProfileViewController.h"
#import "NBSImagesCollectionContainerViewController.h"
#import "UIViewController+RESideMenu.h"
#import "RESideMenu.h"
#import "NBSNavigationController.h"
#import "NBSInstructionsViewController.h"
#import "UIViewController+NBSNavigationItems.h"
#import "NBSDesignAdditions.h"
#import "NBSAboutProjectViewController.h"
#import "NBSJoinGroupViewController.h"

enum
{
    kCPMenuProfileRow = 0,
    kCPMenuDrawRow,
    kCPMenuAboutProjectRow,
    kCPMenuHelpRow,
    kCPMenuNumberOfRows
};

NSString *const kNBSMenuVCIdentifier = @"MenuVC";

@interface NBSMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation NBSMenuViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    switch (indexPath.row) {
        case kCPMenuProfileRow:
            cell.textLabel.text = NSLocalizedString(@"MenuProfileTitle", nil);
            break;
        case kCPMenuDrawRow:
            cell.textLabel.text = NSLocalizedString(@"MenuDrawTitle", nil);
            break;
        case kCPMenuAboutProjectRow:
            cell.textLabel.text = NSLocalizedString(@"MenuAboutProjectTitle", nil);
            break;
        case kCPMenuHelpRow:
            cell.textLabel.text = NSLocalizedString(@"MenuHelpTitle", nil);
            break;
        default:
            break;
    }
    [cell.textLabel replaceFontWithStandartLightFont];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kCPMenuNumberOfRows;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewController = nil;
    
    switch (indexPath.row) {
        case kCPMenuProfileRow:
        {
            NBSProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:kNBSProfileVCIdentifier];
            viewController = profileVC;
        }
            break;
        case kCPMenuDrawRow:
        {
            NBSImagesCollectionContainerViewController *imagesCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:kNBSImagesCollectionVCIdentifier];
            viewController = imagesCollectionVC;
        }
            break;
        case kCPMenuAboutProjectRow:
        {
            NBSAboutProjectViewController *aboutProjectVC = [self.storyboard instantiateViewControllerWithIdentifier:kNBSAboutProjectVCIdentifier];
            viewController = aboutProjectVC;
        }
            break;
        case kCPMenuHelpRow: {
            NBSInstructionsViewController *helpVC = [self.storyboard instantiateViewControllerWithIdentifier:kNBSHelpVCIdentifier];
            [helpVC setSkipButtonHidden:YES];
            viewController = helpVC;
        }
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

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

@end
