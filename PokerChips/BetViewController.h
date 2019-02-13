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

@property (strong, nonatomic) IBOutlet UIView *potView;
@property (weak, nonatomic) IBOutlet UIButton *qrCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;

@property (weak, nonatomic) IBOutlet UIView *potChipsView;
@property (weak, nonatomic) IBOutlet UIView *betChipsView;
@property (weak, nonatomic) IBOutlet UIView *playerChipsView;

@property (weak, nonatomic) IBOutlet ChipView *potRed;
@property (weak, nonatomic) IBOutlet ChipView *potBlue;
@property (weak, nonatomic) IBOutlet ChipView *potGreen;
@property (weak, nonatomic) IBOutlet ChipView *potBlack;
@property (weak, nonatomic) IBOutlet ChipView *potPurple;

@property (weak, nonatomic) IBOutlet UIView *qrCodeView;
@property (weak, nonatomic) IBOutlet UIView *addChipsView;

@property (weak, nonatomic) IBOutlet UIButton *addChipsButtonOutlet;

@property (weak, nonatomic) IBOutlet UILabel *betTotal;
@property (weak, nonatomic) IBOutlet UILabel *potTotal;


//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addChipsTopConstraint;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playerChipsHeightConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *betChipsCenterYConstraint;

@property (weak, nonatomic) IBOutlet ChipView *betRed;
@property (weak, nonatomic) IBOutlet ChipView *betBlue;
@property (weak, nonatomic) IBOutlet ChipView *betYellow;
@property (weak, nonatomic) IBOutlet ChipView *betGreen;
@property (weak, nonatomic) IBOutlet ChipView *betOrange;

@property (weak, nonatomic) IBOutlet ChipView *playerRed;
@property (weak, nonatomic) IBOutlet ChipView *playerBlue;
@property (weak, nonatomic) IBOutlet ChipView *playerYellow;
@property (weak, nonatomic) IBOutlet ChipView *playerGreen;
@property (weak, nonatomic) IBOutlet ChipView *playerOrange;

@end
