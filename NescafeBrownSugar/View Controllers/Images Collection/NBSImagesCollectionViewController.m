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

@interface NBSImagesCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *sourceImagesNames;
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

- (void)setupSource {
    //fill source array with images' names here
    self.sourceImagesNames = @[@"butterfly", @"fenix", @"panda"];
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //show navigation bar
//    [self setupCustomNavigationBarItems];
    [self.navigationController setNavigationBarHidden:NO];
    self.title = @"Choose an image";
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.sourceImagesNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ImageCellIdentifier";
    
    NBSImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                                 forIndexPath:indexPath];

    NSAssert(cell, @"We was wrong - cell is nil in images collection view");
    
    cell.imageThumbView.image = [UIImage imageNamed:[self.sourceImagesNames objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate 

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.selectedTemplateImageName = self.sourceImagesNames[indexPath.row];
    [self performSegueWithIdentifier:@"MainWorkScreenPushSegue" sender:self];
}

@end
