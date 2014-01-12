//
//  NBSInstructionsViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/2/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSInstructionsViewController.h"
#import "NBSInstructionsContentViewController.h"

#define kNBSInstructionsCount 5
#define kNBSInstructionsFirstPageIndex 0

NSString *const kNBSHelpNavigationVCIdentifier = @"RootHelpNavigationVC";
NSString *const kNBSHelpVCIdentifier = @"HelpVC";


@interface NBSInstructionsViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@end

@implementation NBSInstructionsViewController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - public
- (void)setSkipButtonHidden:(BOOL)hidden {
    self.skipButton.hidden = hidden;
    [self.view layoutIfNeeded];
}

#pragma mark -  view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

//    //hide skip button if we came from main menu
//    self.skipButton.hidden = !(BOOL)(self.presentingViewController);
    
    //setup page controll
    self.pageControl.numberOfPages = kNBSInstructionsCount;
    
    //move page view controller to first page
    NBSInstructionsContentViewController *firstPage = [self viewControllerAtIndex:kNBSInstructionsFirstPageIndex];
    if (firstPage) {
        [self.pageViewController setViewControllers:@[firstPage]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL finished) {
            
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //hide navigation
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kNBSInstructionsFillContentSegueIdentifier]) {
        self.pageViewController = (UIPageViewController *)segue.destinationViewController;
        [self addChildViewController:self.pageViewController];
        [self.pageViewController didMoveToParentViewController:self];
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
    }
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){return;}
    
    //find index of current page
    NBSInstructionsContentViewController *currentInstructionsContentViewController =
        (NBSInstructionsContentViewController *)[self.pageViewController.viewControllers lastObject];
    //update page controll
    self.pageControl.currentPage = currentInstructionsContentViewController.pageIndex;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((NBSInstructionsContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        DLog(@"wrong index for current page controller");
        return nil;
    }
    
    if (index == 0) {
        return nil; // return nothing if current page is first
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((NBSInstructionsContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        DLog(@"wrong index for current page controller");
        return nil;
    }
    
    index++;
    if (index == kNBSInstructionsCount) {
        return nil; // return nothing if current page is last
    }
    return [self viewControllerAtIndex:index];
}

- (NBSInstructionsContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    //if there is no pages or index greater than pages number
    if ((kNBSInstructionsCount == 0) || (index >= kNBSInstructionsCount)) {
        return nil;
    }
    
    //create a new page and setup source data.
    NBSInstructionsContentViewController *instructionsContentPage = [self.storyboard instantiateViewControllerWithIdentifier:kNBSInstructionsContentVCIdentifier];
    instructionsContentPage.pageIndex = index;
    
    return instructionsContentPage;
}

@end
