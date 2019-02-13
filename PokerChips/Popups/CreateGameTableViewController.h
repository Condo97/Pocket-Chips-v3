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

@property (weak, nonatomic) IBOutlet UILabel *redValue;
@property (weak, nonatomic) IBOutlet UILabel *blueValue;
@property (weak, nonatomic) IBOutlet UILabel *yellowValue;
@property (weak, nonatomic) IBOutlet UILabel *greenValue;
@property (weak, nonatomic) IBOutlet UILabel *orangeValue;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *chipValueSelector;

@property (strong, nonatomic) NetworkHandler *nh;

@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *chipValuesForSelector;

@end
