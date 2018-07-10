//
//  GameObject.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

- (id)initWithIdentifier:(NSString *)identifier andName:(NSString *)name {
    self = [super init];
    self.identifier = identifier;
    self.name = name;
    
    return self;
}

@end
