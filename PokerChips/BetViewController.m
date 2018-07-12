//
//  BetViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/4/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "BetViewController.h"
#import "NHAlignmentFlowLayout.h"
#import "PlayerObject.h"
#import "UserListTableViewController.h"

#define CELL_SPACING 10

@interface BetViewController ()

@property (strong, nonatomic) NSMutableArray *chipLabelArray, *chipCountArray, *potChipsArray, *playerObjectArray;
@property (strong, nonatomic) NetworkHandler *nh;
@property (strong, nonatomic) UIVisualEffectView *blur, *addChipsBlur;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) NSString *aca;

@end

@implementation BetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.qrCodeView setHidden:YES];
    [self.qrCodeView setAlpha:0.0];
    
    [self.addChipsView setHidden:YES];
    [self.addChipsView setAlpha:0.0];
    
    if(self.view.frame.size.width == 375)
        [self.playerChipsHeightConstraint setConstant:190];
    else if(self.view.frame.size.width == 414)
        [self.playerChipsHeightConstraint setConstant:210];
    
    if(self.view.frame.size.height > 740)
        [self.betChipsCenterYConstraint setConstant:-15];
    
    self.aca = @"";
    
    self.potChipsArray = [NSMutableArray arrayWithObjects:self.dealerRed, self.dealerBlue, self.dealerGreen, self.dealerBlack, self.dealerPurple, nil];
    self.playerObjectArray = [[NSMutableArray alloc] init];
    
    self.blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.blur setFrame:self.view.frame];
    
    [self.blur setHidden:YES];
    [self.blur setAlpha:0.0];
    [self.view addSubview:self.blur];
    [self.view insertSubview:self.blur belowSubview:self.qrCodeView];
    
    self.addChipsBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.addChipsBlur setFrame:self.view.frame];
    [self.addChipsBlur setHidden:YES];
    [self.addChipsBlur setAlpha:0.0];
    [self.view addSubview:self.addChipsBlur];
    [self.view insertSubview:self.addChipsBlur belowSubview:self.addChipsView];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeQRView)];
    [self.view addGestureRecognizer:self.tap];
    [self.tap setEnabled:NO];
    
    if(@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat topPadding = window.safeAreaInsets.top;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;
        CGRect blurFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size
                                      .height + topPadding + bottomPadding);
        [self.blur setFrame:blurFrame];
        [self.addChipsBlur setFrame:blurFrame];
    }
    
    QRViewController *bvc = self.childViewControllers[0];
    //BetViewController *bvc = (BetViewController *)nav;
    [bvc setGameId:self.gameId];
    [bvc setDelegate:self];
    
    AddChipsViewController *acvc = self.childViewControllers[1];
    [acvc setDelegate:self];
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"Background"] convertToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)]]];
    
    NSLog(@"gameId:%@\nplayerId:%@", self.gameId, self.playerId);
    self.chipLabelArray = [[NSMutableArray alloc] init];
    self.chipCountArray = [[NSMutableArray alloc] init];
    self.chipsToBet = [[ChipObject alloc] init];
    
    self.nh = [NetworkHandler sharedInstance];
    
    [self.nh setDelegate:self];
    
//    NSString *response = [NSString stringWithFormat:@"gc:%@\n", self.playerId];
//    NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
//    [self.nh writeData:data];
    
    NSString *response = [NSString stringWithFormat:@"na:%@\n", self.gameId];
    NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
    [self.nh writeData:data];
    
    //iPhone Only Chip stuff
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //Chips (player and bet) setup
        self.playerRedChip = [[PokerChipView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) andImage:[UIImage imageNamed:@"chip0"]];
        self.playerBlueChip = [[PokerChipView alloc] initWithFrame:CGRectMake(self.playerChipsView.frame.size.width / 2 - 50, 0, 100, 100) andImage:[UIImage imageNamed:@"chip1"]];
        self.playerChipGreen = [[PokerChipView alloc] initWithFrame:CGRectMake(self.playerChipsView.frame.size.width - 100, 0, 100, 100) andImage:[UIImage imageNamed:@"chip2"]];
        self.playerChipBlack = [[PokerChipView alloc] initWithFrame:CGRectMake(self.playerChipsView.frame.size.width / 3 - 50, self.playerChipsView.frame.size.height - 100, 100, 100) andImage:[UIImage imageNamed:@"chip3"]];
        self.playerChipPurple = [[PokerChipView alloc] initWithFrame:CGRectMake(2 * self.playerChipsView.frame.size.width / 3 - 50, self.playerChipsView.frame.size.height - 100, 100, 100) andImage:[UIImage imageNamed:@"chip4"]];
        [self.playerChipsView addSubview:self.playerRedChip];
        [self.playerChipsView addSubview:self.playerBlueChip];
        [self.playerChipsView addSubview:self.playerChipGreen];
        [self.playerChipsView addSubview:self.playerChipBlack];
        [self.playerChipsView addSubview:self.playerChipPurple];
        
        self.addChipsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if(self.view.frame.size.height > 740)
            [self.addChipsButton setFrame:CGRectMake(self.view.frame.size.width / 2.0 - ((self.view.frame.size.width * 0.203) / 2.0), self.view.frame.size.height * (1275.0 / 1920.0) - 35.0, (self.view.frame.size.width * 0.203), 50)];
        else
            [self.addChipsButton setFrame:CGRectMake(self.view.frame.size.width / 2.0 - ((self.view.frame.size.width * 0.203) / 2.0), self.view.frame.size.height * (1275.0 / 1920.0) - 15.0, (self.view.frame.size.width * 0.203), 50)];
        
        [self.addChipsButton addTarget:self action:@selector(addChipButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.addChipsButton setTitle:@"+ Chips" forState:UIControlStateNormal]; //Add Chips
        [self.addChipsButton.titleLabel setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightSemibold]];
        [self.addChipsButton.titleLabel setMinimumScaleFactor:0.1];
        [self.addChipsButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [self.addChipsButton.titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [self.view addSubview:self.addChipsButton];
        [self.view insertSubview:self.addChipsButton belowSubview:self.qrCodeView];
        
        self.betRedChip = [[PokerChipView alloc] initWithFrame:CGRectMake(0, 55 / 2, 55, 55) andImage:[UIImage imageNamed:@"chip0Minus"]];
        self.betBlueChip = [[PokerChipView alloc] initWithFrame:CGRectMake(self.betChipsView.frame.size.width / 2 - (55 / 2), 0, 55, 55) andImage:[UIImage imageNamed:@"chip1Minus"]];
        self.betGreenChip = [[PokerChipView alloc] initWithFrame:CGRectMake(self.betChipsView.frame.size.width - 55, (55 / 2), 55, 55) andImage:[UIImage imageNamed:@"chip2Minus"]];
        self.betBlackChip = [[PokerChipView alloc] initWithFrame:CGRectMake(self.betChipsView.frame.size.width / 3 - (55 / 2), self.betChipsView.frame.size.height - 55, 55, 55) andImage:[UIImage imageNamed:@"chip3Minus"]];
        self.betPurpleChip = [[PokerChipView alloc] initWithFrame:CGRectMake(2 * self.betChipsView.frame.size.width / 3 - (55 / 2), self.betChipsView.frame.size.height - 55, 55, 55) andImage:[UIImage imageNamed:@"chip4Minus"]];
        [self.betChipsView addSubview:self.betRedChip];
        [self.betChipsView addSubview:self.betBlueChip];
        [self.betChipsView addSubview:self.betGreenChip];
        [self.betChipsView addSubview:self.betBlackChip];
        [self.betChipsView addSubview:self.betPurpleChip];
    }
    
    [self.view bringSubviewToFront:self.addChipsBlur];
    [self.view bringSubviewToFront:self.addChipsView];
    [self.view bringSubviewToFront:self.blur];
    [self.view bringSubviewToFront:self.qrCodeView];
    
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)addChipsButtonPad:(id)sender {
    [self addChipButtonPressed];
}

- (void)updateView {
    [self.potChipsArray[0] setText:[NSString stringWithFormat:@"%ld", (long)self.potChips.red]];
    [self.potChipsArray[1] setText:[NSString stringWithFormat:@"%ld", (long)self.potChips.blue]];
    [self.potChipsArray[2] setText:[NSString stringWithFormat:@"%ld", (long)self.potChips.green]];
    [self.potChipsArray[3] setText:[NSString stringWithFormat:@"%ld", (long)self.potChips.black]];
    [self.potChipsArray[4] setText:[NSString stringWithFormat:@"%ld", (long)self.potChips.purple]];
    
    //Pot chips
    if(self.potChips.red == 0)
        [self.potRed setHidden:YES];
    else
        [self.potRed setHidden:NO];
    
    if(self.potChips.blue == 0)
        [self.potBlue setHidden:YES];
    else
        [self.potBlue setHidden:NO];
    
    if(self.potChips.green == 0)
        [self.potGreen setHidden:YES];
    else
        [self.potGreen setHidden:NO];
    
    if(self.potChips.black == 0)
        [self.potBlack setHidden:YES];
    else
        [self.potBlack setHidden:NO];
    
    if(self.potChips.purple == 0)
        [self.potPurple setHidden:YES];
    else
        [self.potPurple setHidden:NO];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.playerRedChip setLabelTextWithDouble:self.playerChips.red];
        [self.playerBlueChip setLabelTextWithDouble:self.playerChips.blue];
        [self.playerChipGreen setLabelTextWithDouble:self.playerChips.green];
        [self.playerChipBlack setLabelTextWithDouble:self.playerChips.black];
        [self.playerChipPurple setLabelTextWithDouble:self.playerChips.purple];
        
        [self.betRedChip setLabelTextWithDouble:self.chipsToBet.red];
        [self.betBlueChip setLabelTextWithDouble:self.chipsToBet.blue];
        [self.betGreenChip setLabelTextWithDouble:self.chipsToBet.green];
        [self.betBlackChip setLabelTextWithDouble:self.chipsToBet.black];
        [self.betPurpleChip setLabelTextWithDouble:self.chipsToBet.purple];
        
        //To Bet
        if(self.chipsToBet.red == 0)
            [self.betRedChip setHidden:YES];
        else
            [self.betRedChip setHidden:NO];
        
        if(self.chipsToBet.blue == 0)
            [self.betBlueChip setHidden:YES];
        else
            [self.betBlueChip setHidden:NO];
        
        if(self.chipsToBet.green == 0)
            [self.betGreenChip setHidden:YES];
        else
            [self.betGreenChip setHidden:NO];
        
        if(self.chipsToBet.black == 0)
            [self.betBlackChip setHidden:YES];
        else
            [self.betBlackChip setHidden:NO];
        
        if(self.chipsToBet.purple == 0)
            [self.betPurpleChip setHidden:YES];
        else
            [self.betPurpleChip setHidden:NO];
    } else {
        [self.padPlayerRedLabel setText:[NSString stringWithFormat:@"%.0f", self.playerChips.red]];
        [self.padPlayerBlueLabel setText:[NSString stringWithFormat:@"%.0f",self.playerChips.blue]];
        [self.padPlayerGreenLabel setText:[NSString stringWithFormat:@"%.0f",self.playerChips.green]];
        [self.padPlayerGrayLabel setText:[NSString stringWithFormat:@"%.0f",self.playerChips.black]];
        [self.padPlayerPurpleLabel setText:[NSString stringWithFormat:@"%.0f",self.playerChips.purple]];
        
        [self.padBetRedLabel setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.red]];
        [self.padBetBlueLabel setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.blue]];
        [self.padBetGreenLabel setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.green]];
        [self.padBetGrayLabel setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.black]];
        [self.padBetPurpleLabel setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.purple]];
        
        //To Bet
        if(self.chipsToBet.red == 0)
            [self.padBetRed setHidden:YES];
        else
            [self.padBetRed setHidden:NO];
        
        if(self.chipsToBet.blue == 0)
            [self.padBetBlue setHidden:YES];
        else
            [self.padBetBlue setHidden:NO];
        
        if(self.chipsToBet.green == 0)
            [self.padBetGreen setHidden:YES];
        else
            [self.padBetGreen setHidden:NO];
        
        if(self.chipsToBet.black == 0)
            [self.padBetGray setHidden:YES];
        else
            [self.padBetGray setHidden:NO];
        
        if(self.chipsToBet.purple == 0)
            [self.padBetPurple setHidden:YES];
        else
            [self.padBetPurple setHidden:NO];
    }
}

- (IBAction)qrCodeButton:(id)sender {
    [self.qrCodeView setHidden:NO];
    [self.blur setHidden:NO];
    
    [UIView animateWithDuration:0.25 animations:^ {
        [self.qrCodeView setAlpha:1.0];
        [self.blur setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self.tap setEnabled:YES];
    }];
}

- (void)closeQRView {
    [UIView animateWithDuration:0.25 animations:^ {
        [self.qrCodeView setAlpha:0.0];
        [self.blur setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.qrCodeView setHidden:YES];
        [self.blur setHidden:YES];
        [self.tap setEnabled:NO];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if(touch.view == self.betRedChip) {
                [self.betRedChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip0MinusSelected"]]];
            } else if(touch.view == self.betBlueChip) {
                [self.betBlueChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip1MinusSelected"]]];
            } else if(touch.view == self.betGreenChip) {
                [self.betGreenChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip2MinusSelected"]]];
            } else if(touch.view == self.betBlackChip) {
                [self.betBlackChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip3MinusSelected"]]];
            } else if(touch.view == self.betPurpleChip) {
                [self.betPurpleChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip4MinusSelected"]]];
            } else if(touch.view == self.playerRedChip && self.playerChips.red > 0) {
                [self.playerRedChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip0Selected"]]];
            } else if(touch.view == self.playerBlueChip && self.playerChips.blue > 0) {
                [self.playerBlueChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip1Selected"]]];
            } else if(touch.view == self.playerChipGreen && self.playerChips.green > 0) {
                [self.playerChipGreen setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip2Selected"]]];
            } else if(touch.view == self.playerChipBlack && self.playerChips.black > 0) {
                [self.playerChipBlack setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip3Selected"]]];
            } else if(touch.view == self.playerChipPurple && self.playerChips.purple > 0) {
                [self.playerChipPurple setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip4Selected"]]];
            }
        } else {
            if(touch.view == self.padBetRed) {
                [self.padBetRedImage setImage:[UIImage imageNamed:@"chip0MinusSelected"]];
            } else if(touch.view == self.padBetBlue) {
                [self.padBetBlueImage setImage:[UIImage imageNamed:@"chip1MinusSelected"]];
            } else if(touch.view == self.padBetGreen) {
                [self.padBetGreenImage setImage:[UIImage imageNamed:@"chip2MinusSelected"]];
            } else if(touch.view == self.padBetGray) {
                [self.padBetGrayImage setImage:[UIImage imageNamed:@"chip3MinusSelected"]];
            } else if(touch.view == self.padBetPurple) {
                [self.padBetPurpleImage setImage:[UIImage imageNamed:@"chip4MinusSelected"]];
            } else if(touch.view == self.padBetRed && self.playerChips.red > 0) {
                [self.padBetRedImage setImage:[UIImage imageNamed:@"chip0Selected"]];
            } else if(touch.view == self.padBetBlue && self.playerChips.blue > 0) {
                [self.padBetBlueImage setImage:[UIImage imageNamed:@"chip1Selected"]];
            } else if(touch.view == self.padBetGreen && self.playerChips.green > 0) {
                [self.padBetGreenImage setImage:[UIImage imageNamed:@"chip2Selected"]];
            } else if(touch.view == self.padBetGray && self.playerChips.black > 0) {
                [self.padBetGrayImage setImage:[UIImage imageNamed:@"chip3Selected"]];
            } else if(touch.view == self.padBetPurple && self.playerChips.purple > 0) {
                [self.padBetPurpleImage setImage:[UIImage imageNamed:@"chip4Selected"]];
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if(touch.view == self.betRedChip) {
                [self.chipsToBet setRed:self.chipsToBet.red - 1];
                [self.playerChips setRed:self.playerChips.red + 1];
                [self.betRedChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip0Minus"]]];
                [self updateView];
            } else if(touch.view == self.betBlueChip) {
                [self.chipsToBet setBlue:self.chipsToBet.blue - 1];
                [self.playerChips setBlue:self.playerChips.blue + 1];
                [self.betBlueChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip1Minus"]]];
                [self updateView];
            } else if(touch.view == self.betGreenChip) {
                [self.chipsToBet setGreen:self.chipsToBet.green - 1];
                [self.playerChips setGreen:self.playerChips.green + 1];
                [self.betGreenChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip2Minus"]]];
                [self updateView];
            } else if(touch.view == self.betBlackChip) {
                [self.chipsToBet setBlack:self.chipsToBet.black - 1];
                [self.playerChips setBlack:self.playerChips.black + 1];
                [self.betBlackChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip3Minus"]]];
                [self updateView];
            } else if(touch.view == self.betPurpleChip) {
                [self.chipsToBet setPurple:self.chipsToBet.purple - 1];
                [self.playerChips setPurple:self.playerChips.purple + 1];
                [self.betPurpleChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip4Minus"]]];
                [self updateView];
            } else if(touch.view == self.playerRedChip && self.playerChips.red > 0) {
                [self.chipsToBet setRed:self.chipsToBet.red + 1];
                [self.playerChips setRed:self.playerChips.red - 1];
                [self.playerRedChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip0"]]];
                [self updateView];
            } else if(touch.view == self.playerBlueChip && self.playerChips.blue > 0) {
                [self.chipsToBet setBlue:self.chipsToBet.blue + 1];
                [self.playerChips setBlue:self.playerChips.blue - 1];
                [self.playerBlueChip setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip1"]]];
                [self updateView];
            } else if(touch.view == self.playerChipGreen && self.playerChips.green > 0) {
                [self.chipsToBet setGreen:self.chipsToBet.green + 1];
                [self.playerChips setGreen:self.playerChips.green - 1];
                [self.playerChipGreen setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip2"]]];
                [self updateView];
            } else if(touch.view == self.playerChipBlack && self.playerChips.black > 0) {
                [self.chipsToBet setBlack:self.chipsToBet.black + 1];
                [self.playerChips setBlack:self.playerChips.black - 1];
                [self.playerChipBlack setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip3"]]];
                [self updateView];
            } else if(touch.view == self.playerChipPurple && self.playerChips.purple > 0) {
                [self.chipsToBet setPurple:self.chipsToBet.purple + 1];
                [self.playerChips setPurple:self.playerChips.purple - 1];
                [self.playerChipPurple setImageImageView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chip4"]]];
                [self updateView];
            }
        } else {
            if(touch.view == self.padBetRed) {
                [self.chipsToBet setRed:self.chipsToBet.red - 1];
                [self.playerChips setRed:self.playerChips.red + 1];
                [self.padBetRedImage setImage:[UIImage imageNamed:@"chip0Minus"]];
                [self updateView];
            } else if(touch.view == self.padBetBlue) {
                [self.chipsToBet setBlue:self.chipsToBet.blue - 1];
                [self.playerChips setBlue:self.playerChips.blue + 1];
                [self.padBetBlueImage setImage:[UIImage imageNamed:@"chip1Minus"]];
                [self updateView];
            } else if(touch.view == self.padBetGreen) {
                [self.chipsToBet setGreen:self.chipsToBet.green - 1];
                [self.playerChips setGreen:self.playerChips.green + 1];
                [self.padBetGreenImage setImage:[UIImage imageNamed:@"chip2Minus"]];
                [self updateView];
            } else if(touch.view == self.padBetGray) {
                [self.chipsToBet setBlack:self.chipsToBet.black - 1];
                [self.playerChips setBlack:self.playerChips.black + 1];
                [self.padBetGrayImage setImage:[UIImage imageNamed:@"chip3Minus"]];
                [self updateView];
            } else if(touch.view == self.padBetPurple) {
                [self.chipsToBet setPurple:self.chipsToBet.purple - 1];
                [self.playerChips setPurple:self.playerChips.purple + 1];
                [self.padBetPurpleImage setImage:[UIImage imageNamed:@"chip4Minus"]];
                [self updateView];
            } else if(touch.view == self.padPlayerRed && self.playerChips.red > 0) {
                [self.chipsToBet setRed:self.chipsToBet.red + 1];
                [self.playerChips setRed:self.playerChips.red - 1];
                [self.padPlayerRedImage setImage:[UIImage imageNamed:@"chip0"]];
                [self updateView];
            } else if(touch.view == self.padPlayerBlue && self.playerChips.blue > 0) {
                [self.chipsToBet setBlue:self.chipsToBet.blue + 1];
                [self.playerChips setBlue:self.playerChips.blue - 1];
                [self.padPlayerBlueImage setImage:[UIImage imageNamed:@"chip1"]];
                [self updateView];
            } else if(touch.view == self.padPlayerGreen && self.playerChips.green > 0) {
                [self.chipsToBet setGreen:self.chipsToBet.green + 1];
                [self.playerChips setGreen:self.playerChips.green - 1];
                [self.padPlayerGreenImage setImage:[UIImage imageNamed:@"chip2"]];
                [self updateView];
            } else if(touch.view == self.padPlayerGray && self.playerChips.black > 0) {
                [self.chipsToBet setBlack:self.chipsToBet.black + 1];
                [self.playerChips setBlack:self.playerChips.black - 1];
                [self.padPlayerGrayImage setImage:[UIImage imageNamed:@"chip3"]];
                [self updateView];
            } else if(touch.view == self.padPlayerPurple && self.playerChips.purple > 0) {
                [self.chipsToBet setPurple:self.chipsToBet.purple + 1];
                [self.playerChips setPurple:self.playerChips.purple - 1];
                [self.padPlayerPurpleImage setImage:[UIImage imageNamed:@"chip4"]];
                [self updateView];
            }
        }
    }
}

- (IBAction)winButton:(id)sender {
    if(self.playerObjectArray.count <= 1 || ![self moreThanOneLoggedIn:self.playerObjectArray]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"All players must be logged in to claim the pot!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else {
        NSString *response = [NSString stringWithFormat:@"wa:%@:%@\n", self.playerId, self.gameId];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
    }
}

- (IBAction)betButton:(id)sender {
    if(self.playerObjectArray.count <= 1 || ![self moreThanOneLoggedIn:self.playerObjectArray]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"All players must be logged in to place a bet!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else {
        NSString *response = [NSString stringWithFormat:@"bet:%@:%@:%ld:%ld:%ld:%ld:%ld\n", self.gameId, self.playerId, (long)self.chipsToBet.red, (long)self.chipsToBet.blue, (long)self.chipsToBet.green, (long)self.chipsToBet.black, (long)self.chipsToBet.purple];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
        [self updateView];
    }
}

- (void)addChipButtonPressed {
    if(self.playerObjectArray.count <= 1 || ![self moreThanOneLoggedIn:self.playerObjectArray]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"All players must be logged in to add chips!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else {
        [self.addChipsView setHidden:NO];
        [self.addChipsBlur setHidden:NO];
        
        [UIView animateWithDuration:0.25 animations:^ {
            [self.addChipsView setAlpha:1.0];
            [self.addChipsBlur setAlpha:1.0];
        }];
    }
}

- (void)closeAddChipsView {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [UIView animateWithDuration:0.25 animations:^ {
        [self.addChipsView setAlpha:0.0];
        [self.addChipsBlur setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.addChipsView setHidden:YES];
        [self.addChipsBlur setHidden:YES];
    }];
}

- (void)saveChipsWithRed:(long)red blue:(long)blue green:(long)green black:(long)black purple:(long)purple {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [UIView animateWithDuration:0.25 animations:^ {
        [self.addChipsView setAlpha:0.0];
        [self.addChipsBlur setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.addChipsView setHidden:YES];
        [self.addChipsBlur setHidden:YES];
    }];
    
    NSString *response = [NSString stringWithFormat:@"aca:%@:%@:%ld:%ld:%ld:%ld:%ld\n", self.playerId, self.gameId, red, blue, green, black, purple];
    NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
    [self.nh writeData:data];
}

- (void)messageReceived:(NSString *)message {
    NSLog(@"The Message: %@", message);
    if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"ch"]) {
        NSMutableArray *c = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < 5; i++) {
            [c addObject:[message componentsSeparatedByString:@":"][i + 1]];
        }
        
        [self.playerChips addChipsWithRed:((NSString *)c[0]).doubleValue blue:((NSString *)c[1]).doubleValue green:((NSString *)c[2]).doubleValue black:((NSString *)c[3]).doubleValue purple:((NSString *)c[4]).doubleValue];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"pot"]) {
        NSArray<NSString *> *args = [message componentsSeparatedByString:@":"];
        [self.potChips setAllChipsWithRed:args[1].doubleValue blue:args[2].doubleValue green:args[3].doubleValue black:args[4].doubleValue purple:args[5].doubleValue];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"bet"]) {
        NSArray<NSString *> *args = [message componentsSeparatedByString:@":"];
        [self.chipsToBet resetChips];
        ChipObject *c = [[ChipObject alloc] initWithRed:args[1].doubleValue blue:args[2].doubleValue green:args[3].doubleValue black:args[4].doubleValue purple:args[5].doubleValue];
        
        if(!(c.red == self.playerChips.red && c.blue == self.playerChips.blue && c.green == self.playerChips.green && c.black == self.playerChips.black && c.purple == self.playerChips.purple)) {
            [self.playerChips setAllChipsWithRed:c.red blue:c.blue green:c.green black:c.black purple:c.purple];
        }
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"rp"]) {
        [self.potChips resetChips];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"na"]) {
        [self setTitle:[message componentsSeparatedByString:@":"][1]];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"aca"]) {
        self.aca = [message componentsSeparatedByString:@":"][1];
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Chip Addition" message:[NSString stringWithFormat:@"%@ wants to add %@",[message componentsSeparatedByString:@":"][2], [message componentsSeparatedByString:@":"][3]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *accept = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *response = [NSString stringWithFormat:@"acap:%@:%@:%@\n", self.playerId, self.gameId, self.aca];
            NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
            [self.nh writeData:data];
        }];
        UIAlertAction *decline = [UIAlertAction actionWithTitle:@"Decline" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSString *response = [NSString stringWithFormat:@"acapd:%@:%@:%@\n", self.playerId, self.gameId, self.aca];
            NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
            [self.nh writeData:data];
        }];
        
        [ac addAction:accept];
        [ac addAction:decline];
        
        [self presentViewController:ac animated:YES completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"gg"]) {
        self.playerObjectArray = [[NSMutableArray alloc] init];
        NSArray *firstParse = [message componentsSeparatedByString:@"|"];
        for(int i = 1; i < firstParse.count; i++) {
            NSArray<NSString *> *secondParse = [firstParse[i] componentsSeparatedByString:@":"];
            ChipObject *c = [[ChipObject alloc] initWithRed:secondParse[1].doubleValue blue:secondParse[2].doubleValue green:secondParse[3].doubleValue black:secondParse[4].doubleValue purple:secondParse[5].doubleValue];
            
            BOOL loggedIn = NO;
            if([secondParse[6] isEqualToString:@"li"])
                loggedIn = YES;
            
            PlayerObject *pl = [[PlayerObject alloc] initWithUsername:secondParse[0] andChip:c andLoggedIn:loggedIn];
            
            [self.playerObjectArray addObject:pl];
        }
        
        [self.profileButton setEnabled:YES];
        [self performSegueWithIdentifier:@"usersSegue" sender:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"gglog"]) {
        self.playerObjectArray = [[NSMutableArray alloc] init];
        NSArray *firstParse = [message componentsSeparatedByString:@"|"];
        for(int i = 1; i < firstParse.count; i++) {
            NSArray<NSString *> *secondParse = [firstParse[i] componentsSeparatedByString:@":"];
            ChipObject *c = [[ChipObject alloc] initWithRed:secondParse[1].doubleValue blue:secondParse[2].doubleValue green:secondParse[3].doubleValue black:secondParse[4].doubleValue purple:secondParse[5].doubleValue];
            
            BOOL loggedIn = NO;
            if([secondParse[6] isEqualToString:@"li"])
                loggedIn = YES;
            
            PlayerObject *pl = [[PlayerObject alloc] initWithUsername:secondParse[0] andChip:c andLoggedIn:loggedIn];
            
            [self.playerObjectArray addObject:pl];
        }
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"wa"]) {
        NSString *wa = [message componentsSeparatedByString:@":"][1];
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Chip Addition" message:[NSString stringWithFormat:@"%@ wants to claim the pot.",[message componentsSeparatedByString:@":"][2]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *accept = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *response = [NSString stringWithFormat:@"wap:%@:%@:%@\n", self.playerId, self.gameId, wa];
            NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
            [self.nh writeData:data];
        }];
        UIAlertAction *decline = [UIAlertAction actionWithTitle:@"Decline" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSString *response = [NSString stringWithFormat:@"wapd:%@:%@:%@\n", self.playerId, self.gameId, wa];
            NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
            [self.nh writeData:data];
        }];
        
        [ac addAction:accept];
        [ac addAction:decline];
        
        [self presentViewController:ac animated:NO completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"acapd"]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Chip Addition" message:[NSString stringWithFormat:@"%@ declined your chip addition.", [message componentsSeparatedByString:@":"][1]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        
        [ac addAction:done];
        
        [self presentViewController:ac animated:NO completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"wapd"]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Win" message:[NSString stringWithFormat:@"%@ declined your win.", [message componentsSeparatedByString:@":"][1]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        
        [ac addAction:done];
        
        [self presentViewController:ac animated:NO completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"waerror"]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"All players must be logged in to claim the pot!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"beterror"]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"All players must be logged in to place a bet!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"acaerror"]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"All players must be logged in to add chips!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    }
    
    [self updateView];
}

- (IBAction)profileButton:(id)sender {
    [self.profileButton setEnabled:NO];
    NSString *response = [NSString stringWithFormat:@"gg:%@\n", self.gameId];
    NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
    [self.nh writeData:data];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"usersSegue"]) {
        UINavigationController *nav = [segue destinationViewController];
        UserListTableViewController *ultvc = (UserListTableViewController *)nav.topViewController;
        [ultvc setPlayerObjectArray:self.playerObjectArray];
        [ultvc setGameId:self.gameId];
        [ultvc setPlayerId:self.playerId];
    }
}

- (BOOL)moreThanOneLoggedIn:(NSMutableArray<PlayerObject *> *)thePlayers {
    int count = 0;
    for(PlayerObject *player in thePlayers) {
        if(player.loggedIn)
            count++;
    }
    
    if(count <= 1)
        return NO;
    return YES;
}

@end
