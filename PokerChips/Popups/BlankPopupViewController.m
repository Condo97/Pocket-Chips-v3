//
//  BlankPopupViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/12/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "BlankPopupViewController.h"

@interface BlankPopupViewController ()

@end

@implementation BlankPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setCornerRadius:14.0];
    [self.view setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
