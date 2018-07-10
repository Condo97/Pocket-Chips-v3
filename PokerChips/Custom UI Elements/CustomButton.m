//
//  CustomButton.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 10/30/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (void)drawRect:(CGRect)rect {
    [self.layer setCornerRadius:4.0];
    [self setClipsToBounds:YES];
}

@end
