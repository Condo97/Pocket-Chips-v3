//
//  ChipObject.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/5/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChipObject : NSObject

@property (nonatomic) double red, blue, green, black, purple;

- (id)init;
- (id)initWithRed:(double)r blue:(double)b green:(double)g black:(double)bl purple:(double)p;
- (void)addChipsWithRed:(double)r blue:(double)b green:(double)g black:(double)bl purple:(double)p;
- (void)removeChipsWithRed:(double)r blue:(double)b green:(double)g black:(double)bl purple:(double)p;
- (void)setAllChipsWithRed:(double)r blue:(double)b green:(double)g black:(double)bl purple:(double)p;
- (void)resetChips;

@end
