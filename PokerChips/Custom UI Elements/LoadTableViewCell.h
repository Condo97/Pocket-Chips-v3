//
//  LoadTableViewCell.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 2/12/19.
//  Copyright © 2019 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *gameName;
@property (weak, nonatomic) IBOutlet UILabel *usersList;
@property (weak, nonatomic) IBOutlet UILabel *tapToLoad;

@end
