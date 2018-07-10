//
//  ChipObject.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/5/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "ChipObject.h"

@implementation ChipObject

@synthesize red, blue, green, black, purple;

- (id)init {
    red = 0;
    blue = 0;
    green = 0;
    black = 0;
    purple = 0;
    
    return self;
}

- (id)initWithRed:(double)r blue:(double)b green:(double)g black:(double)bl purple:(double)p {
    red = r;
    blue = b;
    green = g;
    black = bl;
    purple = p;
    
    return self;
}

- (void)addChipsWithRed:(double)r blue:(double)b green:(double)g black:(double)bl purple:(double)p {
    red += r;
    blue += b;
    green += g;
    black += bl;
    purple += p;
}

- (void)removeChipsWithRed:(double)r blue:(double)b green:(double)g black:(double)bl purple:(double)p {
    red -= r;
    blue -= b;
    green -= g;
    black -= bl;
    purple -= p;
}

- (void)setAllChipsWithRed:(double)r blue:(double)b green:(double)g black:(double)bl purple:(double)p {
    red = r;
    blue = b;
    green = g;
    black = bl;
    purple = p;
}

- (void)resetChips {
    red = 0;
    blue = 0;
    green = 0;
    black = 0;
    purple = 0;
}

@end
