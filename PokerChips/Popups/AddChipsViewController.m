//
//  AddChipsViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "AddChipsViewController.h"
#import "NetworkHandler.h"

@interface AddChipsViewController ()

@property (strong, nonatomic) NetworkHandler *nh;

@end

@implementation AddChipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setCornerRadius:14.0];
    [self.view setClipsToBounds:YES];
    
    [self.redField setDelegate:self];
    [self.blueField setDelegate:self];
    [self.greenField setDelegate:self];
    [self.blackField setDelegate:self];
    [self.purpleField setDelegate:self];
    
    self.nh = [NetworkHandler sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)redStepper:(UIStepper *)sender {
    [self.redField setText:[NSString stringWithFormat:@"%ld", (long)sender.value]];
}

- (IBAction)blueStepper:(UIStepper *)sender {
    [self.blueField setText:[NSString stringWithFormat:@"%ld", (long)sender.value]];
}

- (IBAction)greenStepper:(UIStepper *)sender {
    [self.greenField setText:[NSString stringWithFormat:@"%ld", (long)sender.value]];
}

- (IBAction)blackStepper:(UIStepper *)sender {
    [self.blackField setText:[NSString stringWithFormat:@"%ld", (long)sender.value]];
}

- (IBAction)purpleStepper:(UIStepper *)sender {
    [self.purpleField setText:[NSString stringWithFormat:@"%ld", (long)sender.value]];
}

- (IBAction)cancelButton:(id)sender {
    [self.delegate closeAddChipsView];
}

- (IBAction)saveButton:(id)sender {
    [self.delegate saveChipsWithRed:(long)self.redField.text.intValue blue:(long)self.blueField.text.intValue green:(long)self.greenField.text.intValue black:(long)self.blackField.text.intValue purple:(long)self.purpleField.text.intValue];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    [toolbar setBarStyle:UIBarStyleDefault];
    [toolbar setItems:[NSArray arrayWithObjects:
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                       [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButton:)], nil]];
    
    [textField setInputAccessoryView:toolbar];
    
    if(textField.frame.origin.y > (self.view.frame.size.height / 2)) {
        [UIView animateWithDuration:0.25 animations:^ {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, -(textField.frame.origin.y - (self.view.frame.size.height / 3)), self.view.frame.size.width, self.view.frame.size.height)];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^ {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }];
    }
    
    return YES;
}

- (void)doneButton:(UIBarButtonItem *)item {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}

- (void)keyboardDidHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^ {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
