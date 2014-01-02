//
//  NBSLoginViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSLoginViewController.h"

@interface NBSLoginViewController ()

@end

@implementation NBSLoginViewController

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
    
    //hide navigation
    [self.navigationController setNavigationBarHidden:YES];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - IBActions
- (IBAction)didPressFacebookButton:(UIButton *)sender {
}

- (IBAction)didPressVkontakteButton:(UIButton *)sender {
}

- (IBAction)didPressInstagramButton:(UIButton *)sender {
}
    
- (IBAction)didPressSkipButton:(UIButton *)sender {
}
    
@end
