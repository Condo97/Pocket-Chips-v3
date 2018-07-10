//
//  PlayerObject.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChipObject.h"

@interface PlayerObject : NSObject

@property (strong, nonatomic) ChipObject *chip;
@property (strong, nonatomic) NSString *username;
@property (nonatomic) BOOL loggedIn;

- (id)initWithUsername:(NSString *)username andChip:(ChipObject *)chip andLoggedIn:(BOOL)loggedIn;

@end
