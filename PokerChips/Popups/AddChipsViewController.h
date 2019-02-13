//
//  AddChipsViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddChipsViewControllerDelegate <NSObject>
@required
- (void)closeAddChipsView;
- (void)saveChipsWithRed:(long)red blue:(long)blue yellow:(long)green green:(long)black orange:(long)purple;

@end;

@interface AddChipsViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *redField;
@property (weak, nonatomic) IBOutlet UITextField *blueField;
@property (weak, nonatomic) IBOutlet UITextField *yellowField;
@property (weak, nonatomic) IBOutlet UITextField *greenField;
@property (weak, nonatomic) IBOutlet UITextField *orangeField;

@property (weak, nonatomic) IBOutlet UIStepper *redStepper;
@property (weak, nonatomic) IBOutlet UIStepper *blueStepper;
@property (weak, nonatomic) IBOutlet UIStepper *yellowStepper;
@property (weak, nonatomic) IBOutlet UIStepper *greenStepper;
@property (weak, nonatomic) IBOutlet UIStepper *orangeStepper;

@property (weak, nonatomic) IBOutlet UILabel *redValue;
@property (weak, nonatomic) IBOutlet UILabel *blueValue;
@property (weak, nonatomic) IBOutlet UILabel *yellowValue;
@property (weak, nonatomic) IBOutlet UILabel *greenValue;
@property (weak, nonatomic) IBOutlet UILabel *orangeValue;

@property (strong, nonatomic) id<AddChipsViewControllerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray<NSString *> *chipValues;

@end
