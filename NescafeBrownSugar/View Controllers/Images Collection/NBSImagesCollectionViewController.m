//
//  NBSImagesCollectionViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSImagesCollectionViewController.h"
#import "NBSImageCollectionViewCell.h"
#import "UIViewController+NBSNavigationItems.h"
#import "NBSMainWorkViewController.h"

#define kNBSTemplateImagesBaseName @"image_"
#define kNBSTemplateIconsBaseName @"icon_"
#define kNBSTemplateIndexDigitsCount 2
#define kNBSTemplatesNumber 50
#define kNBSTemplatesFirstNumber 1

NSString *const kNBSImagesCollectionVCIdentifier = @"ImagesCollectionVC";
NSString *const kNBSPushImageCollectionFromProfileSegueIdentifier = @"pushImageCollectionFromProfileSegue";

@interface NBSImagesCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

//@property (nonatomic, strong) NSArray *sourceImagesNames;
@property (nonatomic, assign) NSString *selectedTemplateImageName;

@end

@implementation NBSImagesCollectionViewController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// TODO: possibly need to move it to UIImage+NBSTemplate
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
- (NSString *)iconNameForImageWithIndex:(int)index {
    return [self imageNameForImageWithBaseName:kNBSTemplateIconsBaseName
                              indexDigitsCount:kNBSTemplateIndexDigitsCount
                                         index:index];
}

- (NSString *)templateNameForImageWithIndex:(int)index {
    return [self imageNameForImageWithBaseName:kNBSTemplateImagesBaseName
                              indexDigitsCount:kNBSTemplateIndexDigitsCount
                                         index:index];
}

- (NSString *)imageNameForImageWithBaseName:(NSString *)baseName
                           indexDigitsCount:(int)digitsCount
                                      index:(int)index
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterNoStyle;
    formatter.minimumIntegerDigits = digitsCount;
    NSString *number = [formatter stringFromNumber:@(index)];
    NSString *imageName = [baseName stringByAppendingString:number];
    
    return imageName;
}
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


//- (void)setupSource {
//    //fill source array with images' names here
//    self.sourceImagesNames = @[@"butterfly", @"fenix", @"panda"];
//    
//    NSMutableArray *iconsMutableArray = [NSMutableArray array];
//    NSNumberFormatter *formatter = [NSNumberFormatter new];
//    formatter.numberStyle = NSNumberFormatterNoStyle;
//    formatter.minimumIntegerDigits = kNBSTemplateIndexDigitsCount;
//    
//    for (int i = kNBSTemplatesFirstNumber; i < kNBSTemplatesNumber; ++i) {
//        NSString *number = [formatter stringFromNumber:@(i)];
//        UIImage *image = [UIImage imageNamed:[kNBSTemplateIconsBaseName stringByAppendingString:number]];
//        NSAssert(image, @"wrong award animation initialization, image cannot be nil");
//        [iconsMutableArray addObject:image];
//    }
//
//    self.sourceImagesNames = iconsMutableArray;
//}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setupSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pageControl.numberOfPages = floor(self.collectionView.contentSize.width / self.collectionView.frame.size.width) + 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MainWorkScreenPushSegue"]) {
        NBSMainWorkViewController *controller = (NBSMainWorkViewController *)segue.destinationViewController;
        controller.templateImage = [UIImage imageNamed:self.selectedTemplateImageName];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentIndex = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    self.pageControl.currentPage = currentIndex;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
//    return self.sourceImagesNames.count;
    return kNBSTemplatesNumber;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ImageCellIdentifier";
    
    NBSImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                                 forIndexPath:indexPath];

    NSAssert(cell, @"We was wrong - cell is nil in images collection view");
    
    int iconIndex = indexPath.row + kNBSTemplatesFirstNumber; //calculate real index of icon for index path
    cell.imageThumbView.image = [UIImage imageNamed:[self iconNameForImageWithIndex:iconIndex]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate 

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    int templateRealIndex = indexPath.row + kNBSTemplatesFirstNumber;
    self.selectedTemplateImageName = [self templateNameForImageWithIndex:templateRealIndex];
    [self performSegueWithIdentifier:@"MainWorkScreenPushSegue" sender:self];
}

@end
