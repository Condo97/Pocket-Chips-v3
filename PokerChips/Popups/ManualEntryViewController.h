//
//  ManualEntryViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/12/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManualEntryViewControllerDelegate <NSObject>
@required
- (void)joinGameManually:(NSString *)gameId;

@end

@interface ManualEntryViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) id<ManualEntryViewControllerDelegate> delegate;

@end
