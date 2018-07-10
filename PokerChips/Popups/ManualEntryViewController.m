//
//  ManualEntryViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/12/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "ManualEntryViewController.h"

@interface ManualEntryViewController ()

@end

@implementation ManualEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setCornerRadius:14.0];
    [self.view setClipsToBounds:YES];
    
    [self.inputField setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButton:(id)sender {
    if([self.inputField.text containsString:@"ga"])
        [self.delegate joinGameManually:self.inputField.text];
    else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Invalid game ID" message:@"Please enter a valid Game ID." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *close = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        
        [ac addAction:close];
        
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)cancelButton:(id)sender {
    [self.delegate joinGameManually:@""];
}

@end
