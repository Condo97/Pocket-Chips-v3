//
//  QRViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/7/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+MDQRCode.h"
//#import "BetViewController.h"

@protocol QRViewControllerDelegate <NSObject>
@required
- (void)closeQRView;

@end

@class BetViewController;

@interface QRViewController : UIViewController

@property (strong, nonatomic) NSString *gameId;
@property (weak, nonatomic) IBOutlet UIImageView *qrView;


@property (nonatomic, assign) id<QRViewControllerDelegate> delegate;

@end
