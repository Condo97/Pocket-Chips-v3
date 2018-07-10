//
//  CustomLabel.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 1/1/18.
//  Copyright © 2018 Alex Coundouriotis. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.layer setShadowOpacity:0.5];
    [self.layer setShadowRadius:4.0];
    [self.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self setAlpha:1.0];
//    [self.layer setBorderColor:[UIColor blackColor].CGColor];
//    [self.layer setBorderWidth:4.0];
}

@end
