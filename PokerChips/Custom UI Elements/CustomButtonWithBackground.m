//
//  CustomButtonWithBackground.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/12/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "CustomButtonWithBackground.h"

@implementation CustomButtonWithBackground

- (void)drawRect:(CGRect)rect {
    [self.layer setCornerRadius:4.0];
    [self setClipsToBounds:YES];
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ButtonBackground"]];
    [image setFrame:self.bounds];
    [self addSubview:image];
    [self sendSubviewToBack:image];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    [label setText:self.titleLabel.text];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold]];
    [self addSubview:label];
    [self bringSubviewToFront:label];
    
    [self.titleLabel setText:@""];
}

@end
