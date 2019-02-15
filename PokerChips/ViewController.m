//
//  ViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 10/30/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

//Pocket poker? Pocket chips? Yes, Pocket Chips!

#import "ViewController.h"
#import "ScanViewController.h"
#import "BetViewController.h"
#import "ChipObject.h"
#import "GameObject.h"

@interface ViewController ()

@property (strong, nonatomic) NetworkHandler *nh;
@property (strong, nonatomic) NSString *currentGameId, *playerId;
@property (strong, nonatomic) ChipObject *playerChips, *potChips;
@property (strong, nonatomic) GADBannerView *bannerAd;
@property (strong, nonatomic) NSMutableArray<GameObject *> *gameObjects;

@property (nonatomic) BOOL shouldShowAds, finishedScanning;
@property (nonatomic) int groupOf16;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.finishedScanning = NO;
    
    [[StoreKitManager sharedManager] resetKeychainForTesting];
    
    self.gameObjects = [[NSMutableArray alloc] init];
    self.groupOf16 = 0;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[self imageWithImage:[UIImage imageNamed:@"Background"] convertToSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)]]];
    
    self.nh = [NetworkHandler sharedInstance];
    
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] == nil) {
        [self performSegueWithIdentifier:@"createUserSegue" sender:nil];
    } else {
        [self.titleLabel setText:[NSString stringWithFormat:@"\n%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]]];
    }
    
    if(self.shouldShowAds) {
        self.bannerAd = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:CGPointMake((self.view.frame.size.width - kGADAdSizeBanner.size.width) / 2, self.view.frame.size.height - kGADAdSizeBanner.size.height)];
        [self.bannerAd setAdUnitID:@"ca-app-pub-0561860165633355/4114723307"];
        [self.bannerAd setRootViewController:self];
        [self.view addSubview:self.bannerAd];
        [self.bannerAd loadRequest:[GADRequest request]];
        [self.bannerAd setDelegate:self];
    }
    
    [[StoreKitManager sharedManager] setDelegate:self];
    
    if([[KFKeychain loadObjectForKey:@"adsRemoved"] isEqualToString:@"YES"]) {
        [self.restorePurchasesLabel removeFromSuperview];
        [self.removeAdsButton removeFromSuperview];
        [self.removeAdsButton setTitle:@"Ads Removed!" forState:UIControlStateNormal];
        [self.bottomView updateConstraints];
    }
    
//    else {
//        NSString *response = [NSString stringWithFormat:@"li:%@\n", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
//        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
//        [self.nh writeData:data];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.nh setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nh setDelegate:self];
    
    if([[KFKeychain loadObjectForKey:@"adsRemoved"] isEqualToString:@"YES"])
        self.shouldShowAds = NO;
    else
        self.shouldShowAds = YES;
    
    if(self.finishedScanning) {
        if(self.shouldShowAds) {
            
            if([self.interstitial isReady])
                [self.interstitial presentFromRootViewController:self];
            else
                [self performSegueWithIdentifier:@"betSegue" sender:nil];
        } else
            [self performSegueWithIdentifier:@"betSegue" sender:nil];
        
        self.finishedScanning = NO;
    }
    
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-0561860165633355/3985395636"];
    [self.interstitial loadRequest:[GADRequest request]];
    [self.interstitial setDelegate:self];
}

- (IBAction)createGame:(id)sender {
//    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Game Name" message:@"Enter game name here:" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        UITextField *textField = ac.textFields.firstObject;
//        NSString *response = [NSString stringWithFormat:@"ng:%@\n", textField.text];
//        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
//        [self.nh writeData:data];
//    }];
//    [ac addTextFieldWithConfigurationHandler:^(UITextField *tf) {
//        [tf setPlaceholder:@"Game name"];
//        [tf setDelegate:self];
//    }];
//
//    [ac addAction:cancel];
//    [ac addAction:done];
//
//    [self presentViewController:ac animated:NO completion:nil];
    
//    [self.createGameView.view setHidden:NO];
//    [self.blur setHidden:NO];
    
    [self performSegueWithIdentifier:@"createGameSegue" sender:nil];
}

- (IBAction)joinGame:(id)sender {
    BOOL isSimulator = NO;
    self.finishedScanning = YES;
    
    if(isSimulator) {
        NSString *gameId = @"ga6FF5F942508601F60155B3585A68FA2BA839BEFE8BCB64A77FDA0C88AEAB";
        NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
        NSString *response = [NSString stringWithFormat:@"jg:%@:%@\n", userId, gameId];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
    } else
        [self performSegueWithIdentifier:@"scanSegue" sender:nil];
}

- (IBAction)loadGame:(id)sender {
    self.gameObjects = [[NSMutableArray alloc] init];
    self.groupOf16 = 0;
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    NSString *response = [NSString stringWithFormat:@"ugs:%@:%d\n", userId, self.groupOf16];
    NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
    [self.nh writeData:data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)messageReceived:(NSString *)message {
    //NSLog(@"MESSAGE: %@", message);
    if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"us"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:[message componentsSeparatedByString:@":"][1] forKey:@"userId"];
        
        NSString *response = [NSString stringWithFormat:@"li:%@\n", [message componentsSeparatedByString:@":"][1]];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"ga"]) {
        self.currentGameId = [message componentsSeparatedByString:@":"][1];
        NSString *response = [NSString stringWithFormat:@"jg:%@:%@\n", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"], self.currentGameId];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"pl"]) {
        NSArray<NSString *> *args = [message componentsSeparatedByString:@":"];
        self.playerId = args[1];
        self.currentGameId = args[2];
        self.playerChips = [[ChipObject alloc] initWithRed:args[3].doubleValue blue:args[4].doubleValue yellow:args[5].doubleValue green:args[6].doubleValue orange:args[7].doubleValue];
        self.potChips = [[ChipObject alloc] initWithRed:args[8].doubleValue blue:args[9].doubleValue yellow:args[10].doubleValue green:args[11].doubleValue orange:args[12].doubleValue];
        
        if(!self.finishedScanning) {
            if(self.shouldShowAds) {
                if([self.interstitial isReady]) {
                    [self.interstitial presentFromRootViewController:self];
                    self.finishedScanning = NO;
                } else {
                    [self performSegueWithIdentifier:@"betSegue" sender:nil];
                    self.finishedScanning = NO;
                }
            } else {
                [self performSegueWithIdentifier:@"betSegue" sender:nil];
                self.finishedScanning = NO;
            }
        }
        
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"ugs"]) {
        NSMutableArray *players = [[NSMutableArray alloc] init];
        for(int i = 3; i < [message componentsSeparatedByString:@":"].count; i++) [players addObject:[message componentsSeparatedByString:@":"][i]];
        
        GameObject *g = [[GameObject alloc] initWithIdentifier:[message componentsSeparatedByString:@":"][1] andName:[message componentsSeparatedByString:@":"][2] andPlayers:players];
        [self.gameObjects addObject:g];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"uge"]) {
        if([[message componentsSeparatedByString:@":"][1] isEqualToString:@"1"]) {
            self.groupOf16++;
            NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
            NSString *response = [NSString stringWithFormat:@"ugs:%@:%d\n", userId, self.groupOf16];
            NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
            [self.nh writeData:data];
        } else {
            [self performSegueWithIdentifier:@"loadSegue" sender:self.gameObjects];
        }
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"na"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[message componentsSeparatedByString:@":"][1] forKey:@"username"];
        [self.titleLabel setText:[NSString stringWithFormat:@"\n%@",[message componentsSeparatedByString:@":"][1]]];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"plerror"]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Invalid Game ID" message:@"The Game ID does not exist, please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil];
        
        [ac addAction:done];
        
        [self presentViewController:ac animated:YES completion:nil];
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"msg"]) {
        if([message componentsSeparatedByString:@":"].count == 4) {
            NSString *title = [message componentsSeparatedByString:@":"][1];
            NSString *theMessage = [message componentsSeparatedByString:@":"][2];
            NSString *doneAction = [message componentsSeparatedByString:@":"][3];
            
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:theMessage preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:doneAction style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:ac animated:YES completion:nil];
        }
    } else if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"umsg"]) {
        if([message componentsSeparatedByString:@":"].count == 5) {
            NSString *title = [message componentsSeparatedByString:@":"][1];
            NSString *theMessage = [message componentsSeparatedByString:@":"][2];
            NSString *required = [message componentsSeparatedByString:@":"][3];
            int sentBuildVersion = ((NSString *)[message componentsSeparatedByString:@":"][4]).intValue;
            int appBuildVersion = ((NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]).intValue;
            
            if([required isEqualToString:@"0"]) {
                if(appBuildVersion <= sentBuildVersion) {
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:theMessage preferredStyle:UIAlertControllerStyleAlert];
                    [ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
                    [ac addAction:[UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSString *iTunesLink = @"itms://itunes.apple.com/us/app/pocket-chips/id1315195957?mt=8";
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink] options:@{} completionHandler:nil];
                    }]];
                    [self presentViewController:ac animated:YES completion:nil];
                }
            } else {
                if(appBuildVersion <= sentBuildVersion) {
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:theMessage preferredStyle:UIAlertControllerStyleAlert];
                    [ac addAction:[UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        NSString *iTunesLink = @"itms://itunes.apple.com/us/app/pocket-chips/id1315195957?mt=8";
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink] options:@{} completionHandler:nil];
                    }]];
                    [self presentViewController:ac animated:YES completion:nil];
                }
            }
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"betSegue"]) {
        UINavigationController *nav = [segue destinationViewController];
        BetViewController *bvc = (BetViewController *)nav.topViewController;
        [bvc setGameId:self.currentGameId];
        [bvc setPlayerId:self.playerId];
        [bvc setPlayerChips:self.playerChips];
        [bvc setPotChips:self.potChips];
    } else if([segue.identifier isEqualToString:@"loadSegue"]) {
        UINavigationController *nav = [segue destinationViewController];
        LoadGameTableViewController *lgtvc = (LoadGameTableViewController *)nav.topViewController;
        NSMutableArray *gameObjectsToSend = (NSMutableArray *)sender;
        [lgtvc setGameObjects:[[gameObjectsToSend reverseObjectEnumerator] allObjects]];
        [lgtvc setUserId:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    } else if([segue.identifier isEqualToString:@"settingsSegue"]) {
        UINavigationController *nav = [segue destinationViewController];
        SettingsTableViewController *stvc = (SettingsTableViewController *)nav.topViewController;
        [stvc setUserId:[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        [stvc setUsername:[[NSUserDefaults standardUserDefaults] stringForKey:@"username"]];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (IBAction)settingsButton:(id)sender {
    [self performSegueWithIdentifier:@"settingsSegue" sender:nil];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    [self performSegueWithIdentifier:@"betSegue" sender:nil];
}

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue {
    self.finishedScanning = NO;
}

- (IBAction)unwindToMainNoScan:(UIStoryboardSegue *)segue {
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

- (IBAction)changeNickname:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Change Nickname" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = ac.textFields.firstObject;
        NSString *response = [NSString stringWithFormat:@"eun:%@:%@\n", [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], textField.text];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [self.nh writeData:data];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [ac addTextFieldWithConfigurationHandler:^(UITextField *tf) {
        [tf setPlaceholder:(NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
        [tf setDelegate:self];
    }];
    [ac addAction:save];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

/* Remove Ads */
- (IBAction)removeAds:(id)sender {
    [self.removeAdsButton setTitle:@"Processing..." forState:UIControlStateNormal];
    [self.removeAdsButton setEnabled:NO];

    [[StoreKitManager sharedManager] purchase];
}

- (void)purchaseSuccessful {
    if([[KFKeychain loadObjectForKey:@"adsRemoved"] isEqualToString:@"YES"]) {
        [self.restorePurchasesLabel removeFromSuperview];
        [self.removeAdsButton removeFromSuperview];
        [self.removeAdsButton setTitle:@"Ads Removed!" forState:UIControlStateNormal];
        [self.bottomView updateConstraints];
    } else {
        [self.restorePurchasesLabel removeFromSuperview];
        [self.removeAdsButton setEnabled:YES];
        [self.removeAdsButton setTitle:@"Remove Ads" forState:UIControlStateNormal];
    }
}

- (void)purchaseUnsuccessful {
    if([[KFKeychain loadObjectForKey:@"adsRemoved"] isEqualToString:@"YES"]) {
        [self.restorePurchasesLabel removeFromSuperview];
        [self.removeAdsButton removeFromSuperview];
        [self.removeAdsButton setTitle:@"Ads Removed!" forState:UIControlStateNormal];
        [self.bottomView updateConstraints];
    } else {
        [self.removeAdsButton setEnabled:YES];
        [self.removeAdsButton setTitle:@"Remove Ads" forState:UIControlStateNormal];
    }
}


@end
