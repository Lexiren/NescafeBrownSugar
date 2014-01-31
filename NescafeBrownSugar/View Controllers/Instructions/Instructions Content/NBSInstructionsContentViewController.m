//
//  NBSInstructionsContentViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#define kNBSHelpContentImageBaseName @"help"

#import "NBSInstructionsContentViewController.h"
#import "NBSDesignAdditions.h"

NSString *const kNBSInstructionsFillContentSegueIdentifier = @"InstructionsFillContentSegue";
NSString *const kNBSInstructionsContentVCIdentifier = @"InstructionsContentVC";

@interface NBSInstructionsContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (nonatomic, strong) NSArray *helpTexts;

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
    [self.contentLabel replaceFontWithStandartLightFont];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_pageIndex >= 0 && _pageIndex < self.helpTexts.count) {
        self.contentLabel.text = self.helpTexts[_pageIndex];
    }

    NSString *contentImageName = [NSString stringWithFormat:@"%@%d", kNBSHelpContentImageBaseName, _pageIndex + 1];
    self.contentImageView.image = [UIImage imageNamed:contentImageName];
}

- (NSArray *)helpTexts {
    if (!_helpTexts) {
        _helpTexts = @[@"Залогінся через соціальну мережу",
                       @"Намалюй за ескізом",
                       @"Сфотографуй",
                       @"Поділись малюнком",
                       @"Отримай драйвові подарунки"
                       ];
    }
    return _helpTexts;
}

@end
