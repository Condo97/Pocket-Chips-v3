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

@property (strong, nonatomic) NSMutableArray *playerObjectArray, *chipCountArray;
@property (strong, nonatomic) NSMutableArray<ChipView *> *potChipsArray;
@property (strong, nonatomic) NSMutableArray<NSString *> *chipValues;
@property (strong, nonatomic) NSArray<ChipView *> *playerChipsArray, *betChipsArray;
@property (strong, nonatomic) NetworkHandler *nh;
@property (strong, nonatomic) UIVisualEffectView *blur, *addChipsBlur;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (strong, nonatomic) NSString *aca, *gameName;
@property (nonatomic) BOOL appeared;

@end

@implementation BetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.qrCodeView setHidden:YES];
    [self.qrCodeView setAlpha:0.0];
    
    [self.addChipsView setHidden:YES];
    [self.addChipsView setAlpha:0.0];
    
    UIImage *qrImage = [[UIImage imageNamed:@"QR"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *exitImage = [[UIImage imageNamed:@"exit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *profileImage = [[UIImage imageNamed:@"Profile"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.qrCodeButton setImage:qrImage forState:UIControlStateNormal];
    [self.exitButton setImage:exitImage forState:UIControlStateNormal];
    [self.profileButton setImage:profileImage forState:UIControlStateNormal];
    
    [self.qrCodeButton setTintColor:[UIColor whiteColor]];
    [self.exitButton setTintColor:[UIColor whiteColor]];
    [self.profileButton setTintColor:[UIColor whiteColor]];
    
    self.aca = @"";
    self.chipValues = [[NSMutableArray alloc] initWithCapacity:5];
    self.chipValues[0] = @"1";
    self.chipValues[1] = @"5";
    self.chipValues[2] = @"10";
    self.chipValues[3] = @"25";
    self.chipValues[4] = @"100";
    
    self.potChipsArray = [[NSMutableArray alloc] init];
    self.playerChipsArray = [NSArray arrayWithObjects:self.playerRed, self.playerBlue, self.playerYellow, self.playerGreen, self.playerOrange, nil];
    self.betChipsArray = [NSArray arrayWithObjects:self.betRed, self.betBlue, self.betYellow, self.betGreen, self.betOrange, nil];
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
    [bvc setGameId:self.gameId];
    [bvc setDelegate:self];
    
    AddChipsViewController *acvc = self.childViewControllers[1];
    [acvc setChipValues:self.chipValues];
    [acvc setDelegate:self];
    
    self.chipCountArray = [[NSMutableArray alloc] init];
    self.chipsToBet = [[ChipObject alloc] init];
    
    self.nh = [NetworkHandler sharedInstance];
    
    [self.nh setDelegate:self];
    
    NSString *response = [NSString stringWithFormat:@"na:%@\n", self.gameId];
    NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
    [self.nh writeData:data];
    
    [self.view bringSubviewToFront:self.addChipsBlur];
    [self.view bringSubviewToFront:self.addChipsView];
    [self.view bringSubviewToFront:self.blur];
    [self.view bringSubviewToFront:self.qrCodeView];
    
    ChipObject *tempPotChips = [[ChipObject alloc] initWithRed:self.potChips.red blue:self.potChips.blue yellow:self.potChips.yellow green:self.potChips.green orange:self.potChips.orange];
    self.potChips = [[ChipObject alloc] initWithRed:0 blue:0 yellow:0 green:0 orange:0];
    [self updatePotChips:tempPotChips];
    
    self.appeared = NO;
    
    [self updateView];
}

- (void)viewDidLayoutSubviews {
    if(!self.appeared) {
        for(ChipView *cv in self.potChipsArray) {
            int xrand = arc4random_uniform(self.potView.frame.size.width - self.playerRed.frame.size.width);// + self.playerRed.frame.size.width/2;
            int yrand = arc4random_uniform(self.potView.frame.size.height + self.potView.frame.origin.y - self.playerRed.frame.size.height) + self.playerRed.frame.size.height / 7;
            [cv setFrame:CGRectMake(xrand, yrand, self.playerRed.frame.size.width, self.playerRed.frame.size.height)];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.appeared = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)addChipsButtonPad:(id)sender {
    [self addChipButtonPressed];
}

- (void)updateView {
    [self.playerChipsArray[0].chipCount setText:[NSString stringWithFormat:@"%.0f", self.playerChips.red]];
    [self.playerChipsArray[1].chipCount setText:[NSString stringWithFormat:@"%.0f",self.playerChips.blue]];
    [self.playerChipsArray[2].chipCount setText:[NSString stringWithFormat:@"%.0f",self.playerChips.yellow]];
    [self.playerChipsArray[3].chipCount setText:[NSString stringWithFormat:@"%.0f",self.playerChips.green]];
    [self.playerChipsArray[4].chipCount setText:[NSString stringWithFormat:@"%.0f",self.playerChips.orange]];
    
    [self.betChipsArray[0].chipCount setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.red]];
    [self.betChipsArray[1].chipCount setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.blue]];
    [self.betChipsArray[2].chipCount setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.yellow]];
    [self.betChipsArray[3].chipCount setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.green]];
    [self.betChipsArray[4].chipCount setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.orange]];
    
    //To Bet
    [self.betRed setHidden:(self.chipsToBet.red == 0)];
    [self.betBlue setHidden:(self.chipsToBet.blue == 0)];
    [self.betYellow setHidden:(self.chipsToBet.yellow == 0)];
    [self.betGreen setHidden:(self.chipsToBet.green == 0)];
    [self.betOrange setHidden:(self.chipsToBet.orange == 0)];
    
    double betTotal = self.chipsToBet.red * self.chipValues[0].doubleValue + self.chipsToBet.blue * self.chipValues[1].doubleValue + self.chipsToBet.yellow * self.chipValues[2].doubleValue + self.chipsToBet.green * self.chipValues[3].doubleValue + self.chipsToBet.orange * self.chipValues[4].doubleValue;
    if((int)betTotal == betTotal) [self.betTotal setText:[NSString stringWithFormat:@"$%.f", betTotal]];
    else [self.betTotal setText:[NSString stringWithFormat:@"$%.02f", betTotal]];
    
    double potTotal = self.potChips.red * self.chipValues[0].doubleValue + self.potChips.blue * self.chipValues[1].doubleValue + self.potChips.yellow * self.chipValues[2].doubleValue + self.potChips.green * self.chipValues[3].doubleValue + self.potChips.orange * self.chipValues[4].doubleValue;
    if((int)potTotal == potTotal) [self.potTotal setText:[NSString stringWithFormat:@"$%.f", betTotal]];
    else [self.potTotal setText:[NSString stringWithFormat:@"$%.02f", potTotal]];
    
    //Pot chips
//    [self.potRed setHidden:(self.potChips.red == 0)];
//    [self.potBlue setHidden:(self.potChips.blue == 0)];
//    [self.potGreen setHidden:(self.potChips.yellow == 0)];
//    [self.potBlack setHidden:(self.potChips.green == 0)];
//    [self.potPurple setHidden:(self.potChips.orange == 0)];
    
    [self.playerChipsArray[0].chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[0]]];
    [self.playerChipsArray[1].chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[1]]];
    [self.playerChipsArray[2].chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[2]]];
    [self.playerChipsArray[3].chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[3]]];
    [self.playerChipsArray[4].chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[4]]];
    [self.betChipsArray[0].chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[0]]];
    [self.betChipsArray[1].chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[1]]];
    [self.betChipsArray[2].chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[2]]];
    [self.betChipsArray[3].chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[3]]];
    [self.betChipsArray[4].chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[4]]];
    
    double parallelPlayerChips[] = {self.playerChips.red, self.playerChips.blue, self.playerChips.yellow, self.playerChips.green, self.playerChips.orange};
    for(int i = 0; i < self.playerChipsArray.count; i++) {
        if(parallelPlayerChips[i] > 0) {
            ChipView *chip = self.playerChipsArray[i];
            [chip.chip setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chip%d", i]]];
            
            [UIView animateWithDuration:0.05 animations:^{
                [chip setTransform:CGAffineTransformIdentity];
            }];
        }
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
        //Change images and animate
        for(int i = 0; i < self.betChipsArray.count; i++) {
            ChipView *chip = self.betChipsArray[i];
            if(touch.view == chip) {
                [chip.chip setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chip%dMinusSelected", i]]];
                
                [UIView animateWithDuration:0.05 animations:^{
                    [chip setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
                }];
                
                break;
            }
        }
        
        double parallelPlayerChips[] = {self.playerChips.red, self.playerChips.blue, self.playerChips.yellow, self.playerChips.green, self.playerChips.orange};
        for(int i = 0; i < self.playerChipsArray.count; i++) {
            ChipView *chip = self.playerChipsArray[i];
            if(touch.view == chip && parallelPlayerChips[i] > 0) {
                [chip.chip setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chip%dSelected", i]]];
                
                [UIView animateWithDuration:0.05 animations:^{
                    [chip setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
                }];
                
                break;
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in touches) {
        //Adjust chips after tap
        if(touch.view == self.betRed) {
            [self.chipsToBet setRed:self.chipsToBet.red - 1];
            [self.playerChips setRed:self.playerChips.red + 1];
        } else if(touch.view == self.betBlue) {
            [self.chipsToBet setBlue:self.chipsToBet.blue - 1];
            [self.playerChips setBlue:self.playerChips.blue + 1];
        } else if(touch.view == self.betYellow) {
            [self.chipsToBet setYellow:self.chipsToBet.yellow - 1];
            [self.playerChips setYellow:self.playerChips.yellow + 1];
        } else if(touch.view == self.betGreen) {
            [self.chipsToBet setGreen:self.chipsToBet.green - 1];
            [self.playerChips setGreen:self.playerChips.green + 1];
        } else if(touch.view == self.betOrange) {
            [self.chipsToBet setOrange:self.chipsToBet.orange - 1];
            [self.playerChips setOrange:self.playerChips.orange + 1];
        } else if(touch.view == self.playerRed && self.playerChips.red > 0) {
            [self.chipsToBet setRed:self.chipsToBet.red + 1];
            [self.playerChips setRed:self.playerChips.red - 1];
        } else if(touch.view == self.playerBlue && self.playerChips.blue > 0) {
            [self.chipsToBet setBlue:self.chipsToBet.blue + 1];
            [self.playerChips setBlue:self.playerChips.blue - 1];
        } else if(touch.view == self.playerYellow && self.playerChips.yellow > 0) {
            [self.chipsToBet setYellow:self.chipsToBet.yellow + 1];
            [self.playerChips setYellow:self.playerChips.yellow - 1];
        } else if(touch.view == self.playerGreen && self.playerChips.green > 0) {
            [self.chipsToBet setGreen:self.chipsToBet.green + 1];
            [self.playerChips setGreen:self.playerChips.green - 1];
        } else if(touch.view == self.playerOrange && self.playerChips.orange > 0) {
            [self.chipsToBet setOrange:self.chipsToBet.orange + 1];
            [self.playerChips setOrange:self.playerChips.orange - 1];
        }
        
        //Change images and animate
        for(int i = 0; i < self.betChipsArray.count; i++) {
            ChipView *chip = self.betChipsArray[i];
            if(touch.view == chip) {
                [chip.chip setImage:[UIImage imageNamed:[NSString stringWithFormat:@"chip%dMinus", i]]];
                
                [UIView animateWithDuration:0.05 animations:^{
                    [chip setTransform:CGAffineTransformIdentity];
                }];
                
                break;
            }
        }
        
        [self updateView];
    }
}

- (IBAction)winButton:(id)sender {
    if(self.playerObjectArray.count <= 1) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Cannot Claim Pot!" message:@"You are the only player in this game!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else if(![self moreThanOneLoggedIn:self.playerObjectArray]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Cannot Claim Pot" message:@"All players must be logged in to claim the pot!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else if(self.potChips.red == 0 && self.potChips.blue == 0 && self.potChips.yellow == 0 && self.potChips.green == 0 && self.potChips.orange == 0) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"There's nothing in the pot!" preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else {
        NSString *response = [NSString stringWithFormat:@"wa:%@:%@\n", self.playerId, self.gameId];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
    }
}

- (IBAction)betButton:(id)sender {
    if(self.playerObjectArray.count <= 1) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Cannot Bet" message:@"You are the only player in this game!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else if (![self moreThanOneLoggedIn:self.playerObjectArray]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Cannot Bet" message:@"All players must be logged in to place a bet!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else {
        NSString *response = [NSString stringWithFormat:@"bet:%@:%@:%ld:%ld:%ld:%ld:%ld\n", self.gameId, self.playerId, (long)self.chipsToBet.red, (long)self.chipsToBet.blue, (long)self.chipsToBet.yellow, (long)self.chipsToBet.green, (long)self.chipsToBet.orange];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
        [self updateView];
    }
}

- (void)addChipButtonPressed {
    if(self.playerObjectArray.count <= 1) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Cannot Add Chips" message:@"You are the only player in this game!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else if (![self moreThanOneLoggedIn:self.playerObjectArray]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Cannot Add Chips" message:@"All players must be logged in to add chips!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
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

- (void)saveChipsWithRed:(long)red blue:(long)blue yellow:(long)green green:(long)black orange:(long)purple {
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

- (void)updatePotChips:(ChipObject *)newChips {
    BOOL chipsSynced = NO;
    while(!chipsSynced) {
        int random = arc4random_uniform(5);
        BOOL added = NO;
        ChipView *cv = [[NSBundle mainBundle] loadNibNamed:@"ChipView" owner:self options:nil][0];
        
//        [cv setFrame:CGRectMake(xrand, yrand, self.playerRed.frame.size.width, self.playerRed.frame.size.height)];
        
        
        
        if(random == 0 && newChips.red > self.potChips.red) {
            [self.potChips addChipsWithRed:1 blue:0 yellow:0 green:0 orange:0];
            [cv.chip setImage:[UIImage imageNamed:@"chip0"]];
            [cv.chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[0]]];
            [cv.chipPrice setTextColor:[UIColor colorWithRed:198/255.0 green:20/255.0 blue:27/255.0 alpha:1]];
            added = YES;
        } else if(random == 1 && newChips.blue > self.potChips.blue) {
            [self.potChips addChipsWithRed:0 blue:1 yellow:0 green:0 orange:0];
            [cv.chip setImage:[UIImage imageNamed:@"chip1"]];
            [cv.chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[1]]];
            [cv.chipPrice setTextColor:[UIColor colorWithRed:22/255.0 green:71/255.0 blue:197/255.0 alpha:1]];
            added = YES;
        } else if(random == 2 && newChips.yellow > self.potChips.yellow) {
            [self.potChips addChipsWithRed:0 blue:0 yellow:1 green:0 orange:0];
            [cv.chip setImage:[UIImage imageNamed:@"chip2"]];
            [cv.chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[2]]];
            [cv.chipPrice setTextColor:[UIColor colorWithRed:212/255.0 green:199/255.0 blue:65/255.0 alpha:1]];
            added = YES;
        } else if(random == 3 && newChips.green > self.potChips.green) {
            [self.potChips addChipsWithRed:0 blue:0 yellow:0 green:1 orange:0];
            [cv.chip setImage:[UIImage imageNamed:@"chip3"]];
            [cv.chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[3]]];
            [cv.chipPrice setTextColor:[UIColor colorWithRed:92/255.0 green:197/255.0 blue:61/255.0 alpha:1]];
            added = YES;
        } else if(random == 4 && newChips.orange > self.potChips.orange) {
            [self.potChips addChipsWithRed:0 blue:0 yellow:0 green:0 orange:1];
            [cv.chip setImage:[UIImage imageNamed:@"chip4"]];
            [cv.chipPrice setText:[NSString stringWithFormat:@"$%@", self.chipValues[4]]];
            [cv.chipPrice setTextColor:[UIColor colorWithRed:202/255.0 green:117/255.0 blue:42/255.0 alpha:1]];
            added = YES;
        }
        
        if(added) {
            [self.potView addSubview:cv];
            [self.potChipsArray addObject:cv];
            int xrand = arc4random_uniform(self.potView.frame.size.width - self.playerRed.frame.size.width);// + self.playerRed.frame.size.width/2;
            int yrand = arc4random_uniform(self.potView.frame.size.height + self.potView.frame.origin.y - self.playerRed.frame.size.height) + self.playerRed.frame.size.height / 7;
            [cv setFrame:CGRectMake(xrand, yrand, self.playerRed.frame.size.width, self.playerRed.frame.size.height)];
        }
        
        if(newChips.red == self.potChips.red && newChips.blue == self.potChips.blue && newChips.yellow == self.potChips.yellow && newChips.green == self.potChips.green && newChips.orange == self.potChips.orange) chipsSynced = YES;
    }
}

- (void)messageReceived:(NSString *)message {
    NSLog(@"The Message: %@", message);
    if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"ch"]) {
        //Add Chips to Player
        NSMutableArray *c = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < 5; i++) {
            [c addObject:[message componentsSeparatedByString:@":"][i + 1]];
        }
        
        [self.playerChips addChipsWithRed:((NSString *)c[0]).doubleValue blue:((NSString *)c[1]).doubleValue yellow:((NSString *)c[2]).doubleValue green:((NSString *)c[3]).doubleValue orange:((NSString *)c[4]).doubleValue];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"pot"]) {
        //Set the Chips in the Pot
        NSArray<NSString *> *args = [message componentsSeparatedByString:@":"];
        //Update Pot Chips in graphic before and after setting
        ChipObject *c = [[ChipObject alloc] initWithRed:args[1].doubleValue blue:args[2].doubleValue yellow:args[3].doubleValue green:args[4].doubleValue orange:args[5].doubleValue];
        [self updatePotChips:c];
        
//        [self.potChips setAllChipsWith
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"bet"]) {
        //Bet to the Pot
        //Clears Bet Chips
        //Sets Player Chips to mirror the Server
        NSArray<NSString *> *args = [message componentsSeparatedByString:@":"];
        [self.chipsToBet resetChips];
        ChipObject *c = [[ChipObject alloc] initWithRed:args[1].doubleValue blue:args[2].doubleValue yellow:args[3].doubleValue green:args[4].doubleValue orange:args[5].doubleValue];
        
        if(!(c.red == self.playerChips.red && c.blue == self.playerChips.blue && c.yellow == self.playerChips.yellow && c.green == self.playerChips.green && c.orange == self.playerChips.orange)) {
            [self.playerChips setAllChipsWithRed:c.red blue:c.blue yellow:c.yellow green:c.green orange:c.orange];
        }
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"rp"]) {
        //Reset Pot Chips
        for(ChipView *cv in self.potChipsArray) [cv removeFromSuperview];
        [self.potChipsArray removeAllObjects];
        
        [self.potChips resetChips];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"na"]) {
        //Get Game Name
        [self setTitle:[message componentsSeparatedByString:@":"][1]];
        self.gameName = [message componentsSeparatedByString:@":"][1];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"aca"]) {
        //Chip Addition verification
        //Presents an alert to let user concent to the addition of Chips
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
        //Get Players in Game and their Chips
        //Sends User to "Users" View
        self.playerObjectArray = [[NSMutableArray alloc] init];
        
        NSString *playersList = @"";
        if([message containsString:@"&"]) {
            playersList = [message componentsSeparatedByString:@"&"][0];
            NSArray<NSString *> *thirdParse = [[message componentsSeparatedByString:@"&"][1] componentsSeparatedByString:@":"];
            self.chipValues[0] = thirdParse[0];
            self.chipValues[1] = thirdParse[1];
            self.chipValues[2] = thirdParse[2];
            self.chipValues[3] = thirdParse[3];
            self.chipValues[4] = thirdParse[4];
        } else playersList = message;
        
        NSArray *firstParse = [playersList componentsSeparatedByString:@"|"];
        for(int i = 1; i < firstParse.count; i++) {
            NSArray<NSString *> *secondParse = [firstParse[i] componentsSeparatedByString:@":"];
            ChipObject *c = [[ChipObject alloc] initWithRed:secondParse[1].doubleValue blue:secondParse[2].doubleValue yellow:secondParse[3].doubleValue green:secondParse[4].doubleValue orange:secondParse[5].doubleValue];
            
            BOOL loggedIn = NO;
            if([secondParse[6] isEqualToString:@"li"])
                loggedIn = YES;
            
            PlayerObject *pl = [[PlayerObject alloc] initWithUsername:secondParse[0] andChip:c andLoggedIn:loggedIn];
            
            [self.playerObjectArray addObject:pl];
        }
        
        [self.profileButton setEnabled:YES];
        [self performSegueWithIdentifier:@"usersSegue" sender:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"gglog"]) {
        //Get Players in Game and their Chips
        //Does not send User to "Users" View
        self.playerObjectArray = [[NSMutableArray alloc] init];
        
        NSString *playersList = @"";
        if([message containsString:@"&"]) {
            playersList = [message componentsSeparatedByString:@"&"][0];
            NSArray<NSString *> *thirdParse = [[message componentsSeparatedByString:@"&"][1] componentsSeparatedByString:@":"];
            self.chipValues[0] = [NSString stringWithFormat:@"%.2f", thirdParse[0].doubleValue];
            self.chipValues[1] = [NSString stringWithFormat:@"%.2f", thirdParse[1].doubleValue];
            self.chipValues[2] = [NSString stringWithFormat:@"%.2f", thirdParse[2].doubleValue];
            self.chipValues[3] = [NSString stringWithFormat:@"%.2f", thirdParse[3].doubleValue];
            self.chipValues[4] = [NSString stringWithFormat:@"%.2f", thirdParse[4].doubleValue];
            
            if(thirdParse[0].doubleValue == thirdParse[0].intValue) self.chipValues[0] = [NSString stringWithFormat:@"%d", thirdParse[0].intValue];
            if(thirdParse[1].doubleValue == thirdParse[1].intValue) self.chipValues[1] = [NSString stringWithFormat:@"%d", thirdParse[1].intValue];
            if(thirdParse[2].doubleValue == thirdParse[2].intValue) self.chipValues[2] = [NSString stringWithFormat:@"%d", thirdParse[2].intValue];
            if(thirdParse[3].doubleValue == thirdParse[3].intValue) self.chipValues[3] = [NSString stringWithFormat:@"%d", thirdParse[3].intValue];
            if(thirdParse[4].doubleValue == thirdParse[4].intValue) self.chipValues[4] = [NSString stringWithFormat:@"%d", thirdParse[4].intValue];
        } else playersList = message;
        
        NSArray *firstParse = [playersList componentsSeparatedByString:@"|"];
        for(int i = 1; i < firstParse.count; i++) {
            NSArray<NSString *> *secondParse = [firstParse[i] componentsSeparatedByString:@":"];
            ChipObject *c = [[ChipObject alloc] initWithRed:secondParse[1].doubleValue blue:secondParse[2].doubleValue yellow:secondParse[3].doubleValue green:secondParse[4].doubleValue orange:secondParse[5].doubleValue];
            
            BOOL loggedIn = NO;
            if([secondParse[6] isEqualToString:@"li"])
                loggedIn = YES;
            
            PlayerObject *pl = [[PlayerObject alloc] initWithUsername:secondParse[0] andChip:c andLoggedIn:loggedIn];
            
            [self.playerObjectArray addObject:pl];
        }
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"wa"]) {
        //Claim Pot verification
        //Presents Alert to allow User to concent to Pot claim
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
        //User's Chip addition was declined
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Chip Addition" message:[NSString stringWithFormat:@"%@ declined your chip addition.", [message componentsSeparatedByString:@":"][1]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        
        [ac addAction:done];
        
        [self presentViewController:ac animated:NO completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"wapd"]) {
        //User's Pot claim was declined
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Claim Pot" message:[NSString stringWithFormat:@"%@ declined your claim.", [message componentsSeparatedByString:@":"][1]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        
        [ac addAction:done];
        
        [self presentViewController:ac animated:NO completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"waerror"]) {
        //All Players are not logged in, cannot claim Pot
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"All players must be logged in to claim the pot!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"beterror"]) {
        //All Players are not logged in, cannot Bet
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"All players must be logged in to place a bet!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"acaerror"]) {
        //All Players are not logged in, cannot add Chips
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
        [ultvc setGameName:self.gameName];
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
