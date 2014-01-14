//
//  NBSImageCollectionContentPageController.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/14/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSImageCollectionContentPageController.h"
#import "NBSImageCollectionViewCell.h"
#import "NBSTemplate.h"

NSString *const kNBSImageCollectionFillContentSegueIdentifier = @"ImageCollectionContainerFillSegue";
NSString *const kNBSImageCollectionContentPageControllerIdentifier = @"CollectionContentControllerIdentifier";

@interface NBSImageCollectionContentPageController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation NBSImageCollectionContentPageController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self setupSource];
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
    //    return self.sourceImagesNames.count;
    return self.sourceTemplates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ImageCellIdentifier";
    
    NBSImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                                 forIndexPath:indexPath];
    NBSTemplate *template = self.sourceTemplates[indexPath.row];
    cell.imageThumbView.image = template.icon;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.didSelectTemplateHandler) {
        self.didSelectTemplateHandler(self.sourceTemplates[indexPath.row]);
    }
}

@end
