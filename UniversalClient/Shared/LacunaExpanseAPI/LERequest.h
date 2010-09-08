//
//  LERequest.h
//  DKTest
//
//  Created by Kevin Runde on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//@class DKDeferred;


@protocol LERequestMonitor

- (void)allRequestsComplete;

@end


@interface LERequest : NSObject {
	SEL callback;
	NSObject *target;
	NSDictionary *response;
	BOOL wasError;
	BOOL handledError;
//	DKDeferred *deferred;
	BOOL canceled;
	NSURLConnection *conn;
	NSMutableData *receivedData;
}


@property (nonatomic, retain) NSDictionary *response;
//@property(nonatomic, retain) DKDeferred *deferred;
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
- (void)cancel;


+ (void)setDelegate:(id<LERequestMonitor>)delegate;
+ (NSInteger)getCurrentRequestCount;
+ (NSString*) stringWithUUID;

@end
