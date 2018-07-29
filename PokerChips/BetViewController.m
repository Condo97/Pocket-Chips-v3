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

@property (strong, nonatomic) NSMutableArray *chipCountArray, *playerObjectArray;
@property (strong, nonatomic) NSArray<ChipView *> *potChipsArray, *playerChipsArray, *betChipsArray;
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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if(self.view.frame.size.height == 736)
            [self.addChipsTopConstraint setConstant:37];
        else if(self.view.frame.size.height == 667)
            [self.addChipsTopConstraint setConstant:27];
        else if(self.view.frame.size.height <= 568)
            [self.addChipsTopConstraint setConstant:23];
    }
    
    if(self.view.frame.size.height > 740)
        [self.betChipsCenterYConstraint setConstant:-15];
    
    self.aca = @"";
    
    self.potChipsArray = [NSArray arrayWithObjects:self.potRed, self.potBlue, self.potGreen, self.potBlack, self.potPurple, nil];
    self.playerChipsArray = [NSArray arrayWithObjects:self.padPlayerRed, self.padPlayerBlue, self.padPlayerGreen, self.padPlayerGray, self.padPlayerPurple, nil];
    self.betChipsArray = [NSArray arrayWithObjects:self.padBetRed, self.padBetBlue, self.padBetGreen, self.padBetGray, self.padBetPurple, nil];
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
    
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)addChipsButtonPad:(id)sender {
    [self addChipButtonPressed];
}

- (void)updateView {
    [self.potChipsArray[0].chipLabel setText:[NSString stringWithFormat:@"%ld", (long)self.potChips.red]];
    [self.potChipsArray[1].chipLabel setText:[NSString stringWithFormat:@"%ld", (long)self.potChips.blue]];
    [self.potChipsArray[2].chipLabel setText:[NSString stringWithFormat:@"%ld", (long)self.potChips.green]];
    [self.potChipsArray[3].chipLabel setText:[NSString stringWithFormat:@"%ld", (long)self.potChips.black]];
    [self.potChipsArray[4].chipLabel setText:[NSString stringWithFormat:@"%ld", (long)self.potChips.purple]];
    
    [self.playerChipsArray[0].chipLabel setText:[NSString stringWithFormat:@"%.0f", self.playerChips.red]];
    [self.playerChipsArray[1].chipLabel setText:[NSString stringWithFormat:@"%.0f",self.playerChips.blue]];
    [self.playerChipsArray[2].chipLabel setText:[NSString stringWithFormat:@"%.0f",self.playerChips.green]];
    [self.playerChipsArray[3].chipLabel setText:[NSString stringWithFormat:@"%.0f",self.playerChips.black]];
    [self.playerChipsArray[4].chipLabel setText:[NSString stringWithFormat:@"%.0f",self.playerChips.purple]];
    
    [self.betChipsArray[0].chipLabel setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.red]];
    [self.betChipsArray[1].chipLabel setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.blue]];
    [self.betChipsArray[2].chipLabel setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.green]];
    [self.betChipsArray[3].chipLabel setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.black]];
    [self.betChipsArray[4].chipLabel setText:[NSString stringWithFormat:@"%.0f",self.chipsToBet.purple]];
    
    //To Bet
    [self.padBetRed setHidden:(self.chipsToBet.red == 0)];
    [self.padBetBlue setHidden:(self.chipsToBet.blue == 0)];
    [self.padBetGreen setHidden:(self.chipsToBet.green == 0)];
    [self.padBetGray setHidden:(self.chipsToBet.black == 0)];
    [self.padBetPurple setHidden:(self.chipsToBet.purple == 0)];
    
    //Pot chips
    [self.potRed setHidden:(self.potChips.red == 0)];
    [self.potBlue setHidden:(self.potChips.blue == 0)];
    [self.potGreen setHidden:(self.potChips.green == 0)];
    [self.potBlack setHidden:(self.potChips.black == 0)];
    [self.potPurple setHidden:(self.potChips.purple == 0)];
    
    double parallelPlayerChips[] = {self.playerChips.red, self.playerChips.blue, self.playerChips.green, self.playerChips.black, self.playerChips.purple};
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
        
        double parallelPlayerChips[] = {self.playerChips.red, self.playerChips.blue, self.playerChips.green, self.playerChips.black, self.playerChips.purple};
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
        if(touch.view == self.padBetRed) {
            [self.chipsToBet setRed:self.chipsToBet.red - 1];
            [self.playerChips setRed:self.playerChips.red + 1];
        } else if(touch.view == self.padBetBlue) {
            [self.chipsToBet setBlue:self.chipsToBet.blue - 1];
            [self.playerChips setBlue:self.playerChips.blue + 1];
        } else if(touch.view == self.padBetGreen) {
            [self.chipsToBet setGreen:self.chipsToBet.green - 1];
            [self.playerChips setGreen:self.playerChips.green + 1];
        } else if(touch.view == self.padBetGray) {
            [self.chipsToBet setBlack:self.chipsToBet.black - 1];
            [self.playerChips setBlack:self.playerChips.black + 1];
        } else if(touch.view == self.padBetPurple) {
            [self.chipsToBet setPurple:self.chipsToBet.purple - 1];
            [self.playerChips setPurple:self.playerChips.purple + 1];
        } else if(touch.view == self.padPlayerRed && self.playerChips.red > 0) {
            [self.chipsToBet setRed:self.chipsToBet.red + 1];
            [self.playerChips setRed:self.playerChips.red - 1];
        } else if(touch.view == self.padPlayerBlue && self.playerChips.blue > 0) {
            [self.chipsToBet setBlue:self.chipsToBet.blue + 1];
            [self.playerChips setBlue:self.playerChips.blue - 1];
        } else if(touch.view == self.padPlayerGreen && self.playerChips.green > 0) {
            [self.chipsToBet setGreen:self.chipsToBet.green + 1];
            [self.playerChips setGreen:self.playerChips.green - 1];
        } else if(touch.view == self.padPlayerGray && self.playerChips.black > 0) {
            [self.chipsToBet setBlack:self.chipsToBet.black + 1];
            [self.playerChips setBlack:self.playerChips.black - 1];
        } else if(touch.view == self.padPlayerPurple && self.playerChips.purple > 0) {
            [self.chipsToBet setPurple:self.chipsToBet.purple + 1];
            [self.playerChips setPurple:self.playerChips.purple - 1];
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
    if(self.playerObjectArray.count <= 1 || ![self moreThanOneLoggedIn:self.playerObjectArray]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Uh oh!" message:@"All players must be logged in to claim the pot!\nConnect more people by tapping the QR button on the upper right." preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:ac animated:YES completion:nil];
    } else if(self.potChips.red == 0 && self.potChips.blue == 0 && self.potChips.green == 0 && self.potChips.black == 0 && self.potChips.purple == 0) {
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
    //NSLog(@"The Message: %@", message);
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
