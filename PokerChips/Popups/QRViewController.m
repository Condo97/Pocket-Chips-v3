//
//  QRViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/7/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "QRViewController.h"

@interface QRViewController ()

@property (strong, nonatomic) BetViewController *bvc;

@end

@implementation QRViewController

@synthesize gameId;
@synthesize delegate = delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.qrView];
    [self.view.layer setCornerRadius:14.0];
    [self.view setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    UIImage *qr = [UIImage mdQRCodeForString:self.gameId size:self.qrView.frame.size.width];
    [self.qrView setImage:qr];
}

- (IBAction)closeButton:(id)sender {
    [self.delegate closeQRView];
}

- (IBAction)manualCode:(id)sender {
    NSString *string = [NSString stringWithFormat:@"Select \"Enter Code Manually\" and enter this Game ID:\n\n%@\n%@\n%@", [self.gameId substringWithRange:NSMakeRange(0, 21)], [self.gameId substringWithRange:NSMakeRange(21, 21)], [self.gameId substringFromIndex:42]];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Game ID" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *copy = [UIAlertAction actionWithTitle:@"Copy" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:self.gameId];
    }];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:done];
    [ac addAction:copy];
    
    [self presentViewController:ac animated:YES completion:nil];
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
