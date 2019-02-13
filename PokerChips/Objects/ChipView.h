//
//  ChipView.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 7/12/18.
//  Copyright © 2018 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChipView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *chip;
@property (strong, nonatomic) IBOutlet UILabel *chipPrice;
@property (strong, nonatomic) IBOutlet UILabel *chipCount;

@end
