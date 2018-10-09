//
//  ScanViewController.m
//  PokerChips
//
//  Created by Alex Coundouriotis on 11/3/17.
//  Copyright © 2017 Alex Coundouriotis. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@property (strong, nonatomic) AVCaptureSession *cs;
@property (strong, nonatomic) NSString *gameId, *userId, *playerId;
@property (nonatomic) BOOL sentResponse;
@property (strong, nonatomic) UIVisualEffectView *helpBlur, *manualEntryBlur;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation ScanViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if(self.view.frame.size.height != 812 || self.view.frame.size.height != 896) {
        [self.iPhoneXScan setHidden:YES];
    }
    
    self.sentResponse = NO;
    
    self.userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"];
    
    ManualEntryViewController *mevc = self.childViewControllers[1];
    [mevc setDelegate:self];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissHelpView)];
    [self.view addGestureRecognizer:self.tap];
    [self.tap setEnabled:NO];
    
    [self.helpView setHidden:YES];
    [self.manualEntryView setHidden:YES];
    
    self.helpBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.helpBlur setFrame:self.view.frame];
    [self.helpBlur setHidden:YES];
    [self.helpBlur setAlpha:0.0];
    [self.view addSubview:self.helpBlur];
    [self.view insertSubview:self.helpBlur belowSubview:self.helpView];
    
    self.manualEntryBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.manualEntryBlur setFrame:self.view.frame];
    [self.manualEntryBlur setHidden:YES];
    [self.manualEntryBlur setAlpha:0.0];
    [self.view addSubview:self.manualEntryBlur];
    [self.view insertSubview:self.manualEntryBlur belowSubview:self.manualEntryView];
    
    self.nh = [NetworkHandler sharedInstance];
    //[self.nh initNetworkCommunication:(CFStringRef)SOCKET_IP_ADDRESS withPort:1234];
    
    NSError *error;
    
    AVCaptureDevice *cd = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:cd error:&error];
    
    if(error == nil) {
        self.cs = [[AVCaptureSession alloc] init];
        [self.cs addInput:input];
        
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [self.cs addOutput:output];
        
        dispatch_queue_t dispatchQueue;
        dispatchQueue = dispatch_queue_create("queue", NULL);
        [output setMetadataObjectsDelegate:self queue:dispatchQueue];
        [output setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
        
        AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.cs];
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [previewLayer setFrame:self.preview.bounds];
        [previewLayer setCornerRadius:4.0];
        [self.view setClipsToBounds:YES];
        [self.preview.layer addSublayer:previewLayer];
        
        CALayer *imageLayer = [[CALayer alloc] init];
        [imageLayer setFrame:self.preview.bounds];
        [imageLayer setContents:[UIImage imageNamed:@"ScanRed"].CGImage];
        [self.preview.layer addSublayer:imageLayer];
        
        [self.cs startRunning];
    }
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if(metadataObjects != nil && metadataObjects.count > 0) {
        for(int i = 0; i < metadataObjects.count; i++) {
            if([metadataObjects[i].type isEqualToString:AVMetadataObjectTypeQRCode] && !self.sentResponse) {
                self.gameId = [metadataObjects[i] stringValue];
                
                if([self.gameId containsString:@"ga"]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        CALayer *imageLayer = [[CALayer alloc] init];
                        [imageLayer setFrame:self.preview.bounds];
                        [imageLayer setContents:[UIImage imageNamed:@"ScanGreen"].CGImage];
                        [self.preview.layer addSublayer:imageLayer];
                    });
                    
                    NSString *response = [NSString stringWithFormat:@"jg:%@:%@\n", self.userId, self.gameId];
                    NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
                    [self.nh writeData:data];
                    [self.cs stopRunning];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self setSentResponse:YES];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButton:(id)sender {
    [self performSegueWithIdentifier:@"exitToMainSegue" sender:self];
}

- (IBAction)helpButtonPressed:(id)sender {
    [self.tap setEnabled:YES];
    
    [self.helpBlur setHidden:NO];
    [self.helpView setHidden:NO];
    
    [UIView animateWithDuration:0.25 animations:^ {
        [self.helpBlur setAlpha:1.0];
        [self.helpView setAlpha:1.0];
    }];
}

- (void)dismissHelpView {
    [self.tap setEnabled:NO];
    
    [UIView animateWithDuration:0.25 animations:^ {
        [self.helpBlur setAlpha:0.0];
        [self.helpView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.helpBlur setHidden:YES];
        [self.helpView setHidden:YES];
    }];
}

- (IBAction)manualEntry:(id)sender {
    [self.manualEntryBlur setHidden:NO];
    [self.manualEntryView setHidden:NO];
    
    [UIView animateWithDuration:0.25 animations:^ {
        [self.manualEntryBlur setAlpha:1.0];
        [self.manualEntryView setAlpha:1.0];
    }];
}

- (void)joinGameManually:(NSString *)gameId {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    [UIView animateWithDuration:0.25 animations:^ {
        [self.manualEntryBlur setAlpha:0.0];
        [self.manualEntryView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.manualEntryBlur setHidden:YES];
        [self.manualEntryView setHidden:YES];
        
        if(gameId.length != 0) {
            [self setSentResponse:YES];
            NSString *response = [NSString stringWithFormat:@"jg:%@:%@\n", self.userId, gameId];
            NSData *data = [response dataUsingEncoding:NSASCIIStringEncoding];
            [self.nh writeData:data];
            [self.cs stopRunning];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
