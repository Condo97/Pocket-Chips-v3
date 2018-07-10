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
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 25, self.view.frame.size.width - 50, cell.frame.size.height - 50)];
        [label setText:@"Currently in no games."];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:27.0 weight:UIFontWeightSemibold]];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setMinimumScaleFactor:0.01];
        [label setTextColor:[UIColor whiteColor]];
        
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell"]];
        [background setFrame:CGRectMake(15, 15, self.view.frame.size.width - 30, cell.frame.size.height - 30)];
        
        if(self.gameObjects.count != 0) {
            UILabel *clickHereLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, cell.frame.size.height - 75, self.view.frame.size.width - 50, 75)];
            [clickHereLabel setTextColor:[UIColor whiteColor]];
            [clickHereLabel setTextAlignment:NSTextAlignmentCenter];
            [clickHereLabel setText:@"(Tap to load)"];
            [clickHereLabel setFont:[UIFont systemFontOfSize:11.0 weight:UIFontWeightRegular]];
            
            [label setText:((GameObject *)self.gameObjects[indexPath.row]).name];
            
            [cell addSubview:clickHereLabel];
        }
        
        [cell addSubview:background];
        [cell addSubview:label];
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width - WIDTH + 50) / 2, 25, WIDTH - 50, HEIGHT - 25)];
        [label setText:@"Currently in no games."];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:27.0 weight:UIFontWeightSemibold]];
        [label setAdjustsFontSizeToFitWidth:YES];
        [label setMinimumScaleFactor:0.01];
        [label setTextColor:[UIColor whiteColor]];
        
        UIImageView *background;
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Cell"]];
        } else {
            background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PadHomeButtons"]];
        }
        
        [background setFrame:CGRectMake((cell.frame.size.width - WIDTH) / 2, 15, WIDTH, cell.frame.size.height - 30)];
        
        [cell addSubview:background];
        [cell addSubview:label];
        
        if(self.gameObjects.count != 0) {
            UILabel *clickHereLabel = [[UILabel alloc] initWithFrame:CGRectMake((cell.frame.size.width - WIDTH) / 2, cell.frame.size.height - 75, WIDTH, 75)];
            [clickHereLabel setTextColor:[UIColor whiteColor]];
            [clickHereLabel setTextAlignment:NSTextAlignmentCenter];
            [clickHereLabel setText:@"(Tap to load)"];
            [clickHereLabel setFont:[UIFont systemFontOfSize:11.0 weight:UIFontWeightRegular]];
            
            [label setText:((GameObject *)self.gameObjects[indexPath.row]).name];
            
            [cell addSubview:clickHereLabel];
        }
        
        return cell;
    }
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
