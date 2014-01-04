//
//  NBSImagesCollectionViewController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSImagesCollectionViewController.h"
#import "NBSImageCollectionViewCell.h"
#import "NBSNavigationController.h"

@interface NBSImagesCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *sourceImagesNames;

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([self.navigationController isKindOfClass:[NBSNavigationController class]]) {
        self.navigationItem.rightBarButtonItem = [(NBSNavigationController *)self.navigationController customRightBarButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
