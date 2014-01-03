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

@interface NBSInstructionsViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@end

@implementation NBSInstructionsViewController

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

    //move page view controller to first page
    NBSInstructionsContentViewController *firstPage = [self viewControllerAtIndex:kNBSInstructionsFirstPageIndex];
    if (firstPage) {
        [self.pageViewController setViewControllers:@[firstPage]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL finished) {
            
        }];
    }
    
    //hide navigation
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FillInstructionsContainer"]) {
        self.pageViewController = (UIPageViewController *)segue.destinationViewController;
        [self addChildViewController:self.pageViewController];
        [self.pageViewController didMoveToParentViewController:self];
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
    }
}

#pragma mark - UIPageViewControllerDelegate
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return kNBSInstructionsCount;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return kNBSInstructionsFirstPageIndex;
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((NBSInstructionsContentViewController*) viewController).pageIndex;
    
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
    NSUInteger index = ((NBSInstructionsContentViewController*) viewController).pageIndex;
    
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
    NBSInstructionsContentViewController *instructionsContentPage = [self.storyboard instantiateViewControllerWithIdentifier:@"InstructionsContentViewController"];
    instructionsContentPage.pageIndex = index;
    
    return instructionsContentPage;
}

@end
