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
#import "NBSDesignAdditions.h"

@interface NBSNavigationController ()

@end

@implementation NBSNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    self.view.backgroundColor = [UIColor clearColor];
    
    UIFont *navigationBarFont = [UIFont standartLightFontWithSize:NBS_isIPhone ?22.f : 40.f];
    self.navigationBar.titleTextAttributes =
  @{NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : navigationBarFont};
    
    [self setNavigationBarHidden:NO animated:NO];
	// Do any additional setup after loading the view.
}

#pragma mark - custom navigation buttons

@end
