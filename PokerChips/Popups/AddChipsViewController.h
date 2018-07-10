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
- (void)saveChipsWithRed:(long)red blue:(long)blue green:(long)green black:(long)black purple:(long)purple;

@end;

@interface AddChipsViewController : UIViewController <UITextFieldDelegate>

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

@property (strong, nonatomic) id<AddChipsViewControllerDelegate> delegate;

@end
