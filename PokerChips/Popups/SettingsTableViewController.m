//
//  SettingsTableViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/21/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nh = [NetworkHandler sharedInstance];
    
    [[StoreKitManager sharedManager] setDelegate:self];
    
    [self.usernameField setText:self.username];
    
    if([[KFKeychain loadObjectForKey:@"adsRemoved"] isEqualToString:@"YES"]) {
        [self.removeAdsButton setEnabled:NO];
        [self.removeAdsButton setTitle:@"Ads Removed!" forState:UIControlStateNormal];
    }
    
    //[[StoreKitManager sharedManager] resetKeychainForTesting];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table view data source

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButton:(id)sender {
    NSString *response = [NSString stringWithFormat:@"eun:%@:%@\n", self.userId, self.usernameField.text];
    NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
    [self.nh writeData:data];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)removeAds:(id)sender {
    [[StoreKitManager sharedManager] purchase];
    
    [self.removeAdsButton setEnabled:NO];
    [self.removeAdsButton setTitle:@"Processing..." forState:UIControlStateNormal];
}

- (IBAction)restorePurchases:(id)sender {
    [[StoreKitManager sharedManager] restorePurchases];
}

- (void)purchaseSuccessful {
    if([[KFKeychain loadObjectForKey:@"adsRemoved"] isEqualToString:@"YES"]) {
        [self.removeAdsButton setEnabled:NO];
        [self.removeAdsButton setTitle:@"Ads Removed!" forState:UIControlStateNormal];
    } else {
        [self.removeAdsButton setEnabled:YES];
        [self.removeAdsButton setTitle:@"Remove Ads ($0.99)" forState:UIControlStateNormal];
    }
}

- (void)purchaseUnsuccessful {
    if([[KFKeychain loadObjectForKey:@"adsRemoved"] isEqualToString:@"YES"]) {
        [self.removeAdsButton setEnabled:NO];
        [self.removeAdsButton setTitle:@"Ads Removed!" forState:UIControlStateNormal];
    } else {
        [self.removeAdsButton setEnabled:YES];
        [self.removeAdsButton setTitle:@"Remove Ads ($0.99)" forState:UIControlStateNormal];
    }
}

@end
