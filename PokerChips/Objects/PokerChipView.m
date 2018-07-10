//
//  PokerChipView.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/8/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "PokerChipView.h"

@implementation PokerChipView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image {
    self = [super initWithFrame:frame];
    
    self.image = [[UIImageView alloc] initWithImage:image];
    [self.image setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    CGFloat width = frame.size.width * 0.31;
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2 - (width / 2), frame.size.height / 2 - (width / 2), width, width)];
    [self.label setMinimumScaleFactor:0.01];
    [self.label setAdjustsFontSizeToFitWidth:YES];
    [self.label setFont:[UIFont systemFontOfSize:17]];
    [self.label setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    
    [self addSubview:self.image];
    [self addSubview:self.label];
    
    return self;
}

- (void)setLabelTextWithDouble:(double)value {
    [self.label setText:[NSString stringWithFormat:@"%ld", (long)value]];
}

- (void)setImageImageView:(UIImageView *)theImageView {
    [self.image setImage:theImageView.image];
}

@end
