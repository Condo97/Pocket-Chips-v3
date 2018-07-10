//
//  PokerChipView.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/8/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PokerChipView : UIView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image;
- (void)setLabelTextWithDouble:(double)value;
- (void)setImageImageView:(UIImageView *)theImageView;

@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UILabel *label;

@end
