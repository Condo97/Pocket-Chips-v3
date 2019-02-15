//
//  StoreKitManager.h
//  Calc
//
//  Created by Alex Coundouriotis on 7/8/17.
//  Copyright © 2017 ACApplications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol StoreKitManagerDelegate <NSObject>

@required
- (void) purchaseSuccessful;
- (void) purchaseUnsuccessful;

@end

@interface StoreKitManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, weak) id<StoreKitManagerDelegate> delegate;

+ (id) sharedManager;
- (BOOL) purchase;
- (void) restorePurchases;

- (void) resetKeychainForTesting;
- (void) removeAdsForTesting;

@end
