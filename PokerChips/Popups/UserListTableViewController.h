//
//  UserListTableViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTableViewCell.h"
#import "PlayerObject.h"
#import "NetworkHandler.h"

@interface UserListTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *playerObjectArray;

@property (strong, nonatomic) NSString *userId, *gameId, *playerId, *gameName; //COMPLETE FUNCTIONALITY

@property (strong, nonatomic) NetworkHandler *nh;

@end
