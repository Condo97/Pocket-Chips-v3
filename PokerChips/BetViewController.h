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
#import "AddChipsViewController.h"
#import "ChipView.h"

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

@property (weak, nonatomic) IBOutlet ChipView *potRed;
@property (weak, nonatomic) IBOutlet ChipView *potBlue;
@property (weak, nonatomic) IBOutlet ChipView *potGreen;
@property (weak, nonatomic) IBOutlet ChipView *potBlack;
@property (weak, nonatomic) IBOutlet ChipView *potPurple;

@property (weak, nonatomic) IBOutlet UIView *qrCodeView;
@property (weak, nonatomic) IBOutlet UIView *addChipsView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *addChipsButtonOutlet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addChipsTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerChipsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betChipsCenterYConstraint;

//iPad Stuff
@property (weak, nonatomic) IBOutlet ChipView *padBetRed;
@property (weak, nonatomic) IBOutlet ChipView *padBetBlue;
@property (weak, nonatomic) IBOutlet ChipView *padBetGreen;
@property (weak, nonatomic) IBOutlet ChipView *padBetGray;
@property (weak, nonatomic) IBOutlet ChipView *padBetPurple;

@property (weak, nonatomic) IBOutlet ChipView *padPlayerRed;
@property (weak, nonatomic) IBOutlet ChipView *padPlayerBlue;
@property (weak, nonatomic) IBOutlet ChipView *padPlayerGreen;
@property (weak, nonatomic) IBOutlet ChipView *padPlayerGray;
@property (weak, nonatomic) IBOutlet ChipView *padPlayerPurple;

@end
