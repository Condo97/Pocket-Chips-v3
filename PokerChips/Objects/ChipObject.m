//
//  ChipObject.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/5/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "ChipObject.h"

@implementation ChipObject

@synthesize red, blue, yellow, green, orange;

- (id)init {
    red = 0;
    blue = 0;
    yellow = 0;
    green = 0;
    orange = 0;
    
    return self;
}

- (id)initWithRed:(double)r blue:(double)b yellow:(double)g green:(double)bl orange:(double)p {
    red = r;
    blue = b;
    yellow = g;
    green = bl;
    orange = p;
    
    return self;
}

- (void)addChipsWithRed:(double)r blue:(double)b yellow:(double)g green:(double)bl orange:(double)p {
    red += r;
    blue += b;
    yellow += g;
    green += bl;
    orange += p;
}

- (void)removeChipsWithRed:(double)r blue:(double)b yellow:(double)g green:(double)bl orange:(double)p {
    red -= r;
    blue -= b;
    yellow -= g;
    green -= bl;
    orange -= p;
}

- (void)setAllChipsWithRed:(double)r blue:(double)b yellow:(double)g green:(double)bl orange:(double)p {
    red = r;
    blue = b;
    yellow = g;
    green = bl;
    orange = p;
}

- (void)resetChips {
    red = 0;
    blue = 0;
    yellow = 0;
    green = 0;
    orange = 0;
}

@end
