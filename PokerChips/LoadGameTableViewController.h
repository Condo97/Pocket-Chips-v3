//
//  LoadGameTableViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"

@interface LoadGameTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray<GameObject *> *gameObjects;
@property (strong, nonatomic) NSString *userId;

@end
