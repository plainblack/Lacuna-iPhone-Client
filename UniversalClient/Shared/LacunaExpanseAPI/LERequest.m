//
//  LERequest.m
//  DKTest
//
//  Created by Kevin Runde on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LERequest.h"
//#import "DKDeferred+JSON.h"
#import "CJSONDataSerializer.h" 
#import "CJSONDeserializer.h"
#import "Session.h"
#import "LEMacros.h"


static int numRequests = 0;
static id<LERequestMonitor> delegate;


@interface LERequest (PrivateMethods)

- (void)sendRequest;
- (void)requestComplete;
- (void)requestFinished;

@end

	
@implementation LERequest


@synthesize response;
//@synthesize deferred;
@synthesize conn;
@synthesize receivedData;


- (id)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	[self init];
	self->canceled = NO;
	self->wasError = NO;
	self->handledError = NO;
	
	self->callback = inCallback;
	self->target = inTarget;
	
	[self->target retain];
	
	numRequests++;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self sendRequest];
	
	return self;
}


- (void)dealloc {
	//NSLog(@"Dealloc called on a LERequest");
	self->callback = nil;
	[self->target release];
	self->target = nil;
	self.response = nil;
//	self.deferred = nil;
	self.conn = nil;
	self.receivedData = nil;
	[super dealloc];
}

- (id)params {
	return nil;
}


- (void)processSuccess {
	NSLog(@"API call success: %@", self.response);
}


- (NSString *)serviceUrl {
	return nil;
}


- (NSString *)methodName {
	return nil;
}


- (id)successCallback:(id)results {
	self->wasError = NO;
	self.response = results;
	[self requestFinished];
	
	[self processSuccess];
	
	[self requestComplete];
	
	return nil;
}

- (id)errorCallback:(NSError *)err {
	NSLog(@"Error: %@", err);
	NSLog(@"Details: %@", err.userInfo);
	
	self->wasError = YES;
	self->handledError = NO;
	self.response = err.userInfo;
	
	if ([self errorCode] == 1006) {
		Session *session = [Session sharedInstance];
		[session reloginTarget:self selector:@selector(reloginComplete)];
	} else {
		[self requestFinished];
		
		[self requestComplete];
	}
	
	return nil;
}


- (BOOL)wasError {
	return self->wasError;
}


- (void)markErrorHandled {
	self->handledError = YES;
}


- (NSString *)errorMessage {
	return [[self.response objectForKey:@"error"] objectForKey:@"message"];
}


- (NSInteger)errorCode {
	return _intv([[self.response objectForKey:@"error"] objectForKey:@"code"]);
}

- (void)requestFinished {
	numRequests--;
	if (numRequests < 1) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[delegate allRequestsComplete];
	}
	
	NSDictionary *result = [self.response objectForKey:@"result"];
	if (result && [result respondsToSelector:@selector(objectForKey:)]) {
		NSDictionary *status = [result objectForKey:@"status"];
		if (status) {
			Session *session = [Session sharedInstance];
			[session processStatus:status];
		}
	}
}


- (void)requestComplete {
	if (!self->canceled) {
		[self->target performSelector:callback withObject:self];

		if (wasError && !handledError) {
			NSString *errorText = [self errorMessage];
			UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Error" message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[av show];
		}
	}
}

- (void)sendRequest {
	Session *session = [Session sharedInstance];
	NSString *url;
	NSString *serviceUrl = [self serviceUrl];
	if ([session.serverUri hasSuffix:@"/"]) {
		if ([serviceUrl hasPrefix:@"/"]) {
			serviceUrl = [serviceUrl substringFromIndex:1];
			url = [NSString stringWithFormat:@"%@%@", session.serverUri, serviceUrl];
		} else {
			url = [NSString stringWithFormat:@"%@%@", session.serverUri, serviceUrl];
		}
	} else {
		if ([serviceUrl hasPrefix:@"/"]) {
			url = [NSString stringWithFormat:@"%@%@", session.serverUri, serviceUrl];
		} else {
			url = [NSString stringWithFormat:@"%@/%@", session.serverUri, serviceUrl];
		}
	}
	
	/*
	id service = [DKDeferred jsonService:url name:[self methodName]];
	self.deferred = [service :[self params]];
	[self.deferred addCallback:callbackTS(self, successCallback:)];
	[self.deferred addErrback:callbackTS(self, errorCallback:)];
	 */
	
	NSDictionary *methodCall = _dict([self methodName], @"method", 
									 [self params], @"params", 
									 [LERequest stringWithUUID], @"id", 
									 @"1.1", @"version");
	
	NSError *error = NULL;
	NSData *jsonData = [[CJSONDataSerializer serializer] serializeObject:methodCall error:&error];
	
	if (!jsonData && error) {
		[self errorCallback:error];
	} else {
		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
		[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		[request setValue:@"TLE iOS Client" forHTTPHeaderField:@"User-Agent"];
		[request setHTTPMethod:@"POST"];
		[request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
		[request setHTTPBody:jsonData];
		
		self.conn = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
		if (self.conn) {
			self.receivedData = [NSMutableData data];
		} else {
			[self errorCallback:[NSError errorWithDomain:@"LERequest" code:1 userInfo:nil]];
		}
	}
}

- (void)cancel {
	self->canceled = YES;
	[self.conn cancel];
	[self errorCallback:[NSError errorWithDomain:@"LERequest" code:2 userInfo:nil]];
}


+ (void)setDelegate:(id<LERequestMonitor>)inDelegate {
	delegate = inDelegate;
}


+ (NSInteger)getCurrentRequestCount {
	return numRequests;
}


- (id)reloginComplete{
	[self sendRequest];
	return nil;
}


#pragma mark -
#pragma mark NSURLConnection Callbacks

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//NSLog(@"Connection finished received %d bytes", [self.receivedData length]);
	NSString *jsonString = [[[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding] autorelease];
	//NSLog(@"Response data: %@", jsonString);
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	//NSLog(@"jsonData: %@", jsonData);
	NSError *error = nil;
	NSDictionary *results = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	//NSLog(@"results: %@", results);
	//NSLog(@"error: %@", error);
	self.conn = nil;
	
	if (!results && error) {
		[self errorCallback:error];
	} else {
		NSDictionary *error = [results objectForKey:@"error"];
		//NSLog(@"results error: %@", error);
		if (isNotNull(error)) {
			[self errorCallback:[NSError errorWithDomain:@"Server Error" code:3  userInfo:_dict(error, @"error")]];
		} else {
			[self successCallback:results];
		}
	}

}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self errorCallback:error];
	self.conn = nil;
}


+ (NSString*) stringWithUUID {
	CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
	//get the string representation of the UUID
	NSString *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
	CFRelease(uuidObj);
	return [uuidString autorelease];
}


@end
