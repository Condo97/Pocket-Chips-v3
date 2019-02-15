//
//  LoadGameTableViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/11/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "LoadGameTableViewController.h"
#import "GameObject.h"
#import "PlayerObject.h"
#import "NetworkHandler.h"
#import "RoundedView.h"
#import "LoadTableViewCell.h"

#define WIDTH 300
#define HEIGHT 100

@interface LoadGameTableViewController ()

@property (strong, nonatomic) NetworkHandler *nh;

@end

@implementation LoadGameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BlankBackground"]]];
    } else {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"PadFelt"]]];
    }
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    if(self.gameObjects.count == 0)
        return 1;
    return self.gameObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *players = @"";
    
    if(self.gameObjects.count != 0) {
        [cell.gameName setText:(self.gameObjects[indexPath.row]).name];
        
        if(self.gameObjects[indexPath.row].players.count >= 1) players = [NSString stringWithFormat:@"With %@", self.gameObjects[indexPath.row].players[0]];
        if(self.gameObjects[indexPath.row].players.count >= 2) players = [NSString stringWithFormat:@"%@, %@", players, self.gameObjects[indexPath.row].players[1]];
        if(self.gameObjects[indexPath.row].players.count >= 3) players = [NSString stringWithFormat:@"%@, %@", players, self.gameObjects[indexPath.row].players[2]];
        if(self.gameObjects[indexPath.row].players.count >= 1) players = [NSString stringWithFormat:@"%@.", players];
        
        [cell.usersList setText:players];
        
    } else {
        [cell.gameName setText:@"Currently in no games."];
        [cell.tapToLoad setText:@"Create or join a game!"];
        [cell.usersList setText:@""];
    }
    
    if(([players isEqualToString:@""] || self.gameObjects.count == 0) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [cell.usersList removeFromSuperview];
        [cell layoutIfNeeded];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(self.gameObjects.count != 0) {
        NSString *output = [NSString stringWithFormat:@"jg:%@:%@\n", self.userId, ((GameObject *)self.gameObjects[indexPath.row]).identifier];
        NSData *data = [output dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.gameObjects.count == 0)
        return NO;
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        GameObject *go = self.gameObjects[indexPath.row];
        
        NSString *output = [NSString stringWithFormat:@"rp:%@:%@\n", self.userId, go.identifier];
        NSData *data = [output dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.gameObjects removeObject:go];
        
        if(self.gameObjects.count == 0) {
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        }
        [self.tableView endUpdates];
        [self.tableView reloadData];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    return HEIGHT + 50;
}

@end
