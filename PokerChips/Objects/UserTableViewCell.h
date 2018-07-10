//
//  UserTableViewCell.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *redChips;
@property (weak, nonatomic) IBOutlet UILabel *blueChips;
@property (weak, nonatomic) IBOutlet UILabel *greenChips;
@property (weak, nonatomic) IBOutlet UILabel *blackChips;
@property (weak, nonatomic) IBOutlet UILabel *purpleChips;

@end
