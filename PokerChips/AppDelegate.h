//
//  AppDelegate.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 10/30/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHandler.h"
//#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NetworkHandlerDataSource>

@property (strong, nonatomic) UIWindow *window;

@end

