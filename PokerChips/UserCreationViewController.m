//
//  UserCreationViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/10/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "UserCreationViewController.h"

@interface UserCreationViewController ()

@property (strong, nonatomic) NetworkHandler *nh;

@end

@implementation UserCreationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nh = [NetworkHandler sharedInstance];
    
    [self.nameField setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.!?@#"] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if(range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    return ([string isEqualToString:filtered] && newLength <= 15);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField.frame.origin.y > (self.view.frame.size.height / 3)) {
        [UIView animateWithDuration:0.25 animations:^ {
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, -70, self.view.frame.size.width, self.view.frame.size.height)];
        }];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25 animations:^ {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)joinButton:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if(self.nameField.text.length > 0) {
        NSString *output = [NSString stringWithFormat:@"reg:%@\n", self.nameField.text];
        NSData *data = [output dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please enter a username." message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:done];
        
        [self presentViewController:alert animated:NO completion:nil];
    }
}

@end
