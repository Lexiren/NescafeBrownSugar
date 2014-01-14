//
//  NBSImageCollectionContentPageController.h
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/14/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBSImageCollectionContentPageController : UIViewController
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSArray *sourceTemplates;
@property (nonatomic, copy) NBSSuccessWithDataCompletionBlock didSelectTemplateHandler;
@end

extern NSString *const kNBSImageCollectionFillContentSegueIdentifier;
extern NSString *const kNBSImageCollectionContentPageControllerIdentifier;
