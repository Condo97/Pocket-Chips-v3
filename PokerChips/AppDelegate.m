//
//  AppDelegate.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 10/30/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "AppDelegate.h"
#import "Defines.pch"
#import <StoreKit/StoreKit.h>

@interface AppDelegate ()

@property (strong, nonatomic) NetworkHandler *nh;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self.nh setDelegate:self];
    
    [[NetworkHandler sharedInstance] initNetworkCommunication:(CFStringRef)SOCKET_IP_ADDRESS withPort:1234];
    
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
        NSString *response = [NSString stringWithFormat:@"li:%@\n", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [[NetworkHandler sharedInstance] writeData:data];
    }
    
    if(@available(iOS 10.4, *)) {
        int r = arc4random_uniform(21);
        if(r == 5)
            [SKStoreReviewController requestReview];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
        NSString *output = [NSString stringWithFormat:@"lo:%@\n", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        NSData *data = [output dataUsingEncoding:NSASCIIStringEncoding];
        [[NetworkHandler sharedInstance] writeData:data];
        [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:NO];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [self.nh setDelegate:self];

    [[NetworkHandler sharedInstance] initNetworkCommunication:(CFStringRef)SOCKET_IP_ADDRESS withPort:1234];

    if([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
        NSString *response = [NSString stringWithFormat:@"li:%@\n", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
        [[NetworkHandler sharedInstance] writeData:data];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
//    [self.nh setDelegate:self];
//    
//    [[NetworkHandler sharedInstance] initNetworkCommunication:(CFStringRef)SOCKET_IP_ADDRESS withPort:1234];
//    
//    if([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] != nil) {
//        NSString *response = [NSString stringWithFormat:@"li:%@\n", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
//        NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
//        [[NetworkHandler sharedInstance] writeData:data];
//    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSString *output = [NSString stringWithFormat:@"lo:%@\n", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"]];
    NSData *data = [output dataUsingEncoding:NSASCIIStringEncoding];
    [[NetworkHandler sharedInstance] writeData:data];
    [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:NO];
}

- (void)messageReceived:(NSString *)message {
    if([[message componentsSeparatedByString:@":"][0] isEqualToString:@"na"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[message componentsSeparatedByString:@":"][1] forKey:@"username"];
    }
}

@end
