//
//  NBSImageCollectionViewCell.m
//  NescafeBrownSugar
//
//  Created by Lexiren on 1/4/14.
//  Copyright (c) 2014 COXO. All rights reserved.
//

#import "NBSImageCollectionViewCell.h"

@interface NBSImageCollectionViewCell ()

@property (nonatomic, strong) UIColor *bgColorNib;

@end

@implementation NBSImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    self.bgColorNib = self.backgroundColor;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.alpha = (highlighted) ? 0.5 : 1.0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
