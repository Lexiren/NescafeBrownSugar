//
//  NBSNavigationController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSNavigationController.h"
#import "NBSUser.h"
#import "NBSLoginViewController.h"

@interface NBSNavigationController ()

@end

@implementation NBSNavigationController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom navigation buttons

- (UIBarButtonItem *)customRightBarButton {    
    return [self loginBarButton];
}

- (UIBarButtonItem *)loginBarButton {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"login"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(didTapLoginButton:)];
    return button;
}

- (void)didTapLoginButton:(id)sender {
//    for (UIViewController *vc in self.viewControllers) {
//        if ([vc isKindOfClass:[NBSLoginViewController class]]) {
//            [self popToViewController:vc animated:YES];
//            return;
//        }
//    }
//    [UIAlertView showErrorAlertWithMessage:@"Navigation Controller didn't find UILoginViewController in navigation hierarhy"];
    NBSLoginViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

@end
