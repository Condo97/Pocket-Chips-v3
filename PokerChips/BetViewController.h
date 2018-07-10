//
//  BetViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/4/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHandler.h"
#import "ChipObject.h"
#import "Defines.pch"
#import "QRViewController.h"
#import "PokerChipView.h"
#import "AddChipsViewController.h"

@interface BetViewController : UIViewController <QRViewControllerDelegate, NetworkHandlerDataSource, AddChipsViewControllerDelegate>

@property (strong, nonatomic) NSString *gameId, *playerId;
@property (strong, nonatomic) ChipObject *playerChips, *potChips, *chipsToBet;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *qrCodeButton;

@property (weak, nonatomic) IBOutlet UIView *potChipsView;
@property (weak, nonatomic) IBOutlet UIView *betChipsView;
@property (weak, nonatomic) IBOutlet UIView *playerChipsView;

@property (weak, nonatomic) IBOutlet UILabel *dealerRed;
@property (weak, nonatomic) IBOutlet UILabel *dealerBlue;
@property (weak, nonatomic) IBOutlet UILabel *dealerGreen;
@property (weak, nonatomic) IBOutlet UILabel *dealerBlack;
@property (weak, nonatomic) IBOutlet UILabel *dealerPurple;

@property (weak, nonatomic) IBOutlet UIView *potRed;
@property (weak, nonatomic) IBOutlet UIView *potBlue;
@property (weak, nonatomic) IBOutlet UIView *potGreen;
@property (weak, nonatomic) IBOutlet UIView *potBlack;
@property (weak, nonatomic) IBOutlet UIView *potPurple;

@property (strong, nonatomic) PokerChipView *betRedChip, *betBlueChip, *betGreenChip, *betBlackChip, *betPurpleChip, *playerRedChip, *playerBlueChip, *playerChipGreen, *playerChipBlack, *playerChipPurple;

@property (weak, nonatomic) IBOutlet UIView *qrCodeView;
@property (weak, nonatomic) IBOutlet UIView *addChipsView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;

@property (strong, nonatomic) UIButton *addChipsButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerChipsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betChipsCenterYConstraint;

//iPad Stuff
@property (weak, nonatomic) IBOutlet UIView *padBetRed;
@property (weak, nonatomic) IBOutlet UIView *padBetBlue;
@property (weak, nonatomic) IBOutlet UIView *padBetGreen;
@property (weak, nonatomic) IBOutlet UIView *padBetGray;
@property (weak, nonatomic) IBOutlet UIView *padBetPurple;

@property (weak, nonatomic) IBOutlet UILabel *padBetRedLabel;
@property (weak, nonatomic) IBOutlet UILabel *padBetBlueLabel;
@property (weak, nonatomic) IBOutlet UILabel *padBetGreenLabel;
@property (weak, nonatomic) IBOutlet UILabel *padBetGrayLabel;
@property (weak, nonatomic) IBOutlet UILabel *padBetPurpleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *padBetRedImage;
@property (weak, nonatomic) IBOutlet UIImageView *padBetBlueImage;
@property (weak, nonatomic) IBOutlet UIImageView *padBetGreenImage;
@property (weak, nonatomic) IBOutlet UIImageView *padBetGrayImage;
@property (weak, nonatomic) IBOutlet UIImageView *padBetPurpleImage;

@property (weak, nonatomic) IBOutlet UIView *padPlayerRed;
@property (weak, nonatomic) IBOutlet UIView *padPlayerBlue;
@property (weak, nonatomic) IBOutlet UIView *padPlayerGreen;
@property (weak, nonatomic) IBOutlet UIView *padPlayerGray;
@property (weak, nonatomic) IBOutlet UIView *padPlayerPurple;

@property (weak, nonatomic) IBOutlet UILabel *padPlayerRedLabel;
@property (weak, nonatomic) IBOutlet UILabel *padPlayerBlueLabel;
@property (weak, nonatomic) IBOutlet UILabel *padPlayerGreenLabel;
@property (weak, nonatomic) IBOutlet UILabel *padPlayerGrayLabel;
@property (weak, nonatomic) IBOutlet UILabel *padPlayerPurpleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *padPlayerRedImage;
@property (weak, nonatomic) IBOutlet UIImageView *padPlayerBlueImage;
@property (weak, nonatomic) IBOutlet UIImageView *padPlayerGreenImage;
@property (weak, nonatomic) IBOutlet UIImageView *padPlayerGrayImage;
@property (weak, nonatomic) IBOutlet UIImageView *padPlayerPurpleImage;

@end
