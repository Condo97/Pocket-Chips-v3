//
//  SettingsTableViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/21/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreKitManager.h"
#import "NetworkHandler.h"
#import "KFKeychain.h"

@interface SettingsTableViewController : UITableViewController <StoreKitManagerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSString *userId, *username;

@property (strong, nonatomic) NetworkHandler *nh;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UIButton *removeAdsButton;

@end
