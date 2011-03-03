//
//  LERequest.h
//  DKTest
//
//  Created by Kevin Runde on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LERequestMonitor

- (void)allRequestsComplete;

@end


@interface LERequest : NSObject {
	SEL callback;
	NSObject *target;
	NSDictionary *response;
	BOOL wasError;
	BOOL handledError;
	BOOL canceled;
	NSURLConnection *conn;
	NSMutableData *receivedData;
	NSInteger retryCount;
}


@property (nonatomic, retain) NSDictionary *response;
@property (retain) NSURLConnection *conn;
@property (retain) NSMutableData *receivedData;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target;
- (void)processSuccess;
- (NSString *)serviceUrl;
- (NSString *)methodName;
- (id)params;
- (BOOL)wasError;
- (void)markErrorHandled;
- (NSString *)errorMessage;
- (NSInteger)errorCode;
- (NSMutableDictionary *)errorData;
- (void)cancel;
- (void)resend;


+ (void)setDelegate:(id<LERequestMonitor>)delegate;
+ (NSInteger)getCurrentRequestCount;
+ (NSString*) stringWithUUID;

@end
