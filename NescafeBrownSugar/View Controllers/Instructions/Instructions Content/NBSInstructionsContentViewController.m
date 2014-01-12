//
//  NBSInstructionsContentViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSInstructionsContentViewController.h"

NSString *const kNBSInstructionsFillContentSegueIdentifier = @"InstructionsFillContentSegue";
NSString *const kNBSInstructionsContentVCIdentifier = @"InstructionsContentVC";

@interface NBSInstructionsContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@end

@implementation NBSInstructionsContentViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.indexLabel.text = [NSString stringWithFormat:@"%d", self.pageIndex+1];
}

@end
