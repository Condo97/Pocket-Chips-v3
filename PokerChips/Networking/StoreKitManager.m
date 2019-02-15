//
//  StoreKitManager.m
//  Calc
//
//  Created by Alex Coundouriotis on 7/8/17.
//  Copyright © 2017 ACApplications. All rights reserved.
//

#import "StoreKitManager.h"
#import "KFKeychain.h"

@interface StoreKitManager ()

@property (strong, nonatomic) SKProductsRequest *productsRequest;
@property (strong, nonatomic) NSArray *validProducts;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSMutableDictionary *productIDs;

@end

@implementation StoreKitManager

+ (id) sharedManager {
    static StoreKitManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void) fetchAvailableProducts {
    NSSet *productIDSet = [NSSet setWithObject:@"removeAdsIAP"];
    
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIDSet];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

- (BOOL) purchase {
    [self fetchAvailableProducts];
    
//    NSDictionary *ringsJson = [NSKeyedUnarchiver unarchiveObjectWithData:[[ArchiverManager sharedManager] loadDataFromDiskWithFileName:@"allJson"]];
//    NSString *currentRingName = [[[JSONManager sharedManager] getRingNamesInOrderWithJSONDictionary:ringsJson] objectAtIndex:ringID];
//    NSDictionary *productIDs = [[JSONManager sharedManager] getRingIAPIDsAsDictionaryWithJSONDictionary:ringsJson];
//    NSString *currentProductID = [productIDs objectForKey:currentRingName];
    
    return YES;
}

#pragma mark - StoreKit stuffs

- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    int count = (int)[response.products count];
    if (count > 0) {
        self.validProducts = response.products;
        
        BOOL canMakePurchases = [SKPaymentQueue canMakePayments];
        
        if(canMakePurchases) {
            SKProduct *product = [self.validProducts objectAtIndex:0]; //MAKE DYNAMIC
            SKPayment *payment = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        } else {
            UIAlertController *tmp = [UIAlertController alertControllerWithTitle:@"Cannot Purchase" message:@"Your device is not configured for purchases." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *doneButton = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
            
            [tmp addAction:doneButton];
        }
    } else {
        UIAlertController *tmp = [UIAlertController alertControllerWithTitle:@"Not Available" message:@"No products to purchase." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *doneButton = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
        
        [tmp addAction:doneButton];
    }
    [self.activityIndicatorView stopAnimating];
}

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: {
                NSLog(@"Purchasing...");
                break;
            }
            case SKPaymentTransactionStatePurchased: {
                NSLog(@"Purchase successful!");
                UIAlertController *tmp = [UIAlertController alertControllerWithTitle:@"Thank you!" message:@"Ads are now removed." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *doneButton = [UIAlertAction actionWithTitle:@"Cool!" style:UIAlertActionStyleDefault handler:nil];
                
                [tmp addAction:doneButton];
                
                [KFKeychain saveObject:@"YES" forKey:@"adsRemoved"];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                id<StoreKitManagerDelegate> storeKitDeleage = self.delegate;
                [storeKitDeleage purchaseSuccessful];
                
                break;
            }
            case SKPaymentTransactionStateRestored: {
                NSLog(@"Restored!");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed: {
                NSLog(@"Purchase failed :(");
                
                id<StoreKitManagerDelegate> storeKitDeleage = self.delegate;
                [storeKitDeleage purchaseUnsuccessful];
                
                break;
            }
            default:
                break;
        }
    }
}

- (void) restorePurchases {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    for (SKPaymentTransaction *transaction in queue.transactions) {
        NSString *productID = transaction.payment.productIdentifier;
        if([productID isEqualToString:@"removeAdsIAP"])
            [KFKeychain saveObject:@"YES" forKey:@"adsRemoved"];
    }
}

- (void) resetKeychainForTesting {
    [KFKeychain saveObject:@"NO" forKey:@"adsRemoved"];
}

- (void) removeAdsForTesting {
    [KFKeychain saveObject:@"YES" forKey:@"adsRemoved"];
}

@end
