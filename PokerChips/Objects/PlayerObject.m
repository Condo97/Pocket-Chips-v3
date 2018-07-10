//
//  PlayerObject.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "PlayerObject.h"

@implementation PlayerObject

- (id)initWithUsername:(NSString *)username andChip:(ChipObject *)chip andLoggedIn:(BOOL)loggedIn {
    self = [super init];
    self.username = username;
    self.chip = chip;
    self.loggedIn = loggedIn;
    
    return self;
}

@end
