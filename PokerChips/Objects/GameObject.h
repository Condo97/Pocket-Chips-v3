//
//  GameObject.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameObject : NSObject

@property (strong, nonatomic) NSString *identifier, *name;
@property (strong, nonatomic) NSArray<NSString *> *players;

- (id)initWithIdentifier:(NSString *)identifier andName:(NSString *)name;
- (id)initWithIdentifier:(NSString *)identifier andName:(NSString *)name andPlayers:(NSArray<NSString *> *)players;

@end
