//
//  NBSImagesCollectionContainerViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/14/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSImagesCollectionContainerViewController.h"
#import "NBSImageCollectionContentPageController.h"
#import "NBSMainWorkViewController.h"
#import "NBSTemplate.h"
#import "UIViewController+NBSNavigationItems.h"

NSString *const kNBSImagesCollectionVCIdentifier = @"ImagesCollectionVCIdentifier";
NSString *const kNBSPushImageCollectionFromProfileSegueIdentifier = @"pushImageCollectionFromProfileSegue";

#define kNBSTemplatesNumberPerPage4Inch 24;
#define kNBSTemplatesNumberPerPage 20;

@interface NBSImagesCollectionContainerViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *sourceTemplatesArray;
@end

@implementation NBSImagesCollectionContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - private

- (int)numberOfTemplatesPerCollectionPage {
    if ((NBS_IsDeviceScreenSize4InchOrBigger)) {
        return kNBSTemplatesNumberPerPage4Inch;
    }
    return kNBSTemplatesNumberPerPage;
}

#pragma mark -  view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    //hide skip button if we came from main menu
    //    self.skipButton.hidden = !(BOOL)(self.presentingViewController);
    
    // -- setup source --
    NSMutableArray *mutableSource = [NSMutableArray array];
    for (int i = 0; i < kNBSTemplatesNumber; ++i) {
        NBSTemplate *template = [[NBSTemplate alloc] initWithIndex:i];
        [mutableSource addObject:template];
    }
    
    self.sourceTemplatesArray = mutableSource;
    
    // -- setup page controll --
    // calculate page numbers
    double realNumberOfPages = (double)self.sourceTemplatesArray.count / (double)[self numberOfTemplatesPerCollectionPage];
    int intNumberOfPages = (int)realNumberOfPages;
    intNumberOfPages += (realNumberOfPages - intNumberOfPages > 0) ? 1 : 0;

    //setup number of pages
    self.pageControl.numberOfPages = intNumberOfPages;
    
    //move page view controller to first page
    NBSImageCollectionContentPageController *firstPage = [self viewControllerAtIndex:0];
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
    [self showLeftMenuBarButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kNBSImageCollectionFillContentSegueIdentifier]) {
        self.pageViewController = (UIPageViewController *)segue.destinationViewController;
        [self addChildViewController:self.pageViewController];
        [self.pageViewController didMoveToParentViewController:self];
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
    } else if ([segue.identifier isEqualToString:kNBSPushMainWorkControllerSegueIdentifier]) {
        NBSMainWorkViewController *mainWorkVC = (NBSMainWorkViewController *)segue.destinationViewController;
        mainWorkVC.sourceImage = [[NBSTemplate currentTemplate] image];
    }
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){return;}
    
    //find index of current page
    NBSImageCollectionContentPageController *currentInstructionsContentViewController =
    (NBSImageCollectionContentPageController *)[self.pageViewController.viewControllers lastObject];
    //update page controll
    self.pageControl.currentPage = currentInstructionsContentViewController.pageIndex;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((NBSImageCollectionContentPageController *) viewController).pageIndex;
    
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
    NSUInteger index = ((NBSImageCollectionContentPageController *) viewController).pageIndex;
    
    if (index == NSNotFound) {
        DLog(@"wrong index for current page controller");
        return nil;
    }
    
    index++;
    if (index == self.pageControl.numberOfPages) {
        return nil; // return nothing if current page is last
    }
    return [self viewControllerAtIndex:index];
}

- (NBSImageCollectionContentPageController *)viewControllerAtIndex:(NSUInteger)index
{
    //if there is no pages or index greater than pages number
    if ((self.pageControl.numberOfPages == 0) || (index >= self.pageControl.numberOfPages)) {
        return nil;
    }
    
    //create a new page and setup source data.
    NBSImageCollectionContentPageController *instructionsContentPage =
     [self.storyboard instantiateViewControllerWithIdentifier:kNBSImageCollectionContentPageControllerIdentifier];
    instructionsContentPage.pageIndex = index;
    
    //setup source data for page content controller
    int numberPerPage = [self numberOfTemplatesPerCollectionPage];
    //calculate how many templates for this and next page we still have
    int restTemplates = self.sourceTemplatesArray.count - index*numberPerPage;
    //range length must be less than or equal rest number of templates - other way produce error during creating sub array
    int rangeLen = (restTemplates > numberPerPage) ? numberPerPage : restTemplates;
    //get indexes of templates for page
    NSIndexSet *indexSetForPage = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index*numberPerPage, rangeLen)];
    //get sub array with templates for page
    instructionsContentPage.sourceTemplates = [self.sourceTemplatesArray objectsAtIndexes:indexSetForPage];
    
    //setup callback for selected template
    __weak NBSImagesCollectionContainerViewController *weakself = self;
    instructionsContentPage.didSelectTemplateHandler = ^(NBSTemplate *template) {
        [NBSTemplate setCurrentTemplate:template];
        [self performSegueWithIdentifier:kNBSPushMainWorkControllerSegueIdentifier sender:weakself];
    };
    
    return instructionsContentPage;
}

@end
