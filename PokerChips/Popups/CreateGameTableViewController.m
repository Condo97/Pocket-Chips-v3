//
//  CreateGameViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/20/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "CreateGameTableViewController.h"
#import "NetworkHandler.h"

@implementation CreateGameTableViewController

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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createButton:(id)sender {
    [self createGameButtonPressed];
}

- (void)createGameButtonPressed {
    if(self.nameField.text.length > 0) {
        [self createGameWithName:self.nameField.text red:(long)self.redField.text.intValue blue:(long)self.blueField.text.intValue green:(long)self.greenField.text.intValue black:(long)self.blackField.text.intValue purple:(long)self.purpleField.text.intValue];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Name" message:@"Please name your new game." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:done];
        
        [self presentViewController:alert animated:NO completion:nil];
    }
}

- (void)createGameWithName:(NSString *)name red:(long)red blue:(long)blue green:(long)green black:(long)black purple:(long)purple {
    NSString *response = [NSString stringWithFormat:@"ng:%@:%ld:%ld:%ld:%ld:%ld\n", name, red, blue, green, black, purple];
    NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
    [self.nh writeData:data];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    if([textField.restorationIdentifier isEqualToString:@"nameField"]) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.!?@#"] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        if(range.length + range.location > textField.text.length) {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        return ([string isEqualToString:filtered] && newLength <= 15);
    }
    
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
    
    if(textField.frame.origin.y > (self.view.frame.size.height / 2 - 50)) {
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
