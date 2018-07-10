//
//  ScanViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/3/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "NetworkHandler.h"
#import "Defines.pch"
#import "ManualEntryViewController.h"

@interface ScanViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, ManualEntryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *preview;
@property (strong, nonatomic) NetworkHandler *nh;

@property (weak, nonatomic) IBOutlet UIView *helpView;
@property (weak, nonatomic) IBOutlet UIView *manualEntryView;

@property (weak, nonatomic) IBOutlet UIImageView *iPhoneXScan;

@end
