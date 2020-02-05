//
//  ViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 10/30/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHandler.h"
#import "Defines.pch"
#import "LoadGameTableViewController.h"
#import "SettingsTableViewController.h"
#import "CustomLabel.h"
#import "RoundedView.h"
@import GoogleMobileAds;

@interface ViewController : UIViewController <NetworkHandlerDataSource, UITextFieldDelegate, GADBannerViewDelegate, GADInterstitialDelegate>

@property (weak, nonatomic) IBOutlet CustomLabel *titleLabel;

@property (strong, nonatomic) GADInterstitial *interstitial;

- (IBAction)unwindToMainNoScan:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet UIButton *removeAdsButton;
@property (weak, nonatomic) IBOutlet UILabel *restorePurchasesLabel;
@property (weak, nonatomic) IBOutlet RoundedView *bottomView;

@property (weak, nonatomic) IBOutlet CustomLabel *welcomeLabel;

@property (nonatomic) BOOL shouldExecuteJG;
@property (strong, nonatomic) NSString *jgMessage;

@end

