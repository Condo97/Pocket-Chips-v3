//
//  CreateGameViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/20/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHandler.h"

@interface CreateGameTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *redField;
@property (weak, nonatomic) IBOutlet UITextField *blueField;
@property (weak, nonatomic) IBOutlet UITextField *greenField;
@property (weak, nonatomic) IBOutlet UITextField *blackField;
@property (weak, nonatomic) IBOutlet UITextField *purpleField;

@property (weak, nonatomic) IBOutlet UIStepper *redStepper;
@property (weak, nonatomic) IBOutlet UIStepper *blueStepper;
@property (weak, nonatomic) IBOutlet UIStepper *greenStepper;
@property (weak, nonatomic) IBOutlet UIStepper *blackStepper;
@property (weak, nonatomic) IBOutlet UIStepper *purpleStepper;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (strong, nonatomic) NetworkHandler *nh;

@end
