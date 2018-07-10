//
//  UserCreationViewController.h
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/10/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkHandler.h"

@interface UserCreationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end
