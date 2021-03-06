//
//  UserListTableViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "UserListTableViewController.h"

#define WIDTH 325
#define HEIGHT 175

@interface UserListTableViewController ()

@end

@implementation UserListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BlankBackground"]]];
    else
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PadFelt"]]];
    
    self.nh = [NetworkHandler sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playerObjectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell.username setText:((PlayerObject *)self.playerObjectArray[indexPath.row]).username];
    
    [cell.redChips setText:[NSString stringWithFormat:@"%ld", (long)((PlayerObject *)self.playerObjectArray[indexPath.row]).chip.red]];
    [cell.blueChips setText:[NSString stringWithFormat:@"%ld", (long)((PlayerObject *)self.playerObjectArray[indexPath.row]).chip.blue]];
    [cell.greenChips setText:[NSString stringWithFormat:@"%ld", (long)((PlayerObject *)self.playerObjectArray[indexPath.row]).chip.green]];
    [cell.blackChips setText:[NSString stringWithFormat:@"%ld", (long)((PlayerObject *)self.playerObjectArray[indexPath.row]).chip.black]];
    [cell.purpleChips setText:[NSString stringWithFormat:@"%ld", (long)((PlayerObject *)self.playerObjectArray[indexPath.row]).chip.purple]];
    
    UIImageView *background;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if(((PlayerObject *)self.playerObjectArray[indexPath.row]).loggedIn)
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell"]];
        else
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellLoggedOut"]];
        [background setFrame:CGRectMake(15, 15, self.view.frame.size.width - 30, cell.frame.size.height - 30)];
    } else {
        if(((PlayerObject *)self.playerObjectArray[indexPath.row]).loggedIn)
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PadHomeButtons"]];
        else
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PadHomeButtonsDark"]];
        [background setFrame:CGRectMake((cell.frame.size.width - WIDTH + 30) / 2, 15, WIDTH - 30, cell.frame.size.height - 30)];
    }
    
    [cell addSubview:background];
    [cell sendSubviewToBack:background];

    return cell;
}

- (IBAction)leaveGameButton:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Leave Game" message:@"Are you sure you want to leave the game?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *response = [NSString stringWithFormat:@"rp:%@:%@\n", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"], self.gameId];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
        
        [(UINavigationController *)self.view.window.rootViewController popToRootViewControllerAnimated:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    
    [controller addAction:yes];
    [controller addAction:no];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)closeButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    return HEIGHT;
}

@end
