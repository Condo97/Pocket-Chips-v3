//
//  NetworkHandler.h
//  ChatCLient
//
//  Created by Alex Coundouriotis on 1/27/17.
//  Copyright © 2017 ACApplications. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkHandlerDataSource <NSObject>
@required
- (void)messageReceived:(NSString *)message;// withContents:(NSArray *)contents;

@end

@interface NetworkHandler : NSObject

@property (nonatomic, assign) NSInputStream *inputStream;
@property (nonatomic, assign) NSOutputStream *outputStream;
@property (nonatomic, assign) id <NetworkHandlerDataSource> delegate;

+ (NetworkHandler *)sharedInstance;
- (NSStreamStatus)initNetworkCommunication:(CFStringRef)ip withPort:(int)port;
- (NSStreamStatus)writeData:(NSData *)data;
- (NSStreamStatus)getStreamStatus;
- (void)closeStream;

@end
