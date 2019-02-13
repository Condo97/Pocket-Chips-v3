//
//  ChipView.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 7/12/18.
//  Copyright © 2018 Alex Coundouriotis. All rights reserved.
//

#import "ChipView.h"

@implementation ChipView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.chip = [[UIImageView alloc] initWithFrame:frame];
    self.chipPrice = [[UILabel alloc] init];
    self.chipCount = [[UILabel alloc] init];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
