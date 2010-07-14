//
//  LERequest.m
//  DKTest
//
//  Created by Kevin Runde on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LERequest.h"
#import "DKDeferred+JSON.h"
#import "Session.h"
#import "LEMacros.h"


static int numRequests = 0;

@interface LERequest (PrivateMethods)

- (void)requestComplete;
- (void)requestFinished;

@end

	
@implementation LERequest


@synthesize response;
@synthesize deferred;
@synthesize protocol;
@synthesize serverName;


- (id)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	[self init];
	canceled = NO;
	wasError = NO;
	handledError = NO;
	
	self.protocol = @"https";
	self.serverName = @"pt.lacunaexpanse.com";
	
	callback = inCallback;
	target = inTarget;
	
	[target retain];
	
	numRequests++;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSString *url = nil;
	if ([[self serviceUrl] hasPrefix:@"/"]) {
		url = [NSString stringWithFormat:@"%@://%@%@", self.protocol, self.serverName, [self serviceUrl]];
	} else {
		url = [NSString stringWithFormat:@"%@://%@/%@", self.protocol, self.serverName, [self serviceUrl]];
	}
	id service = [DKDeferred jsonService:url name:[self methodName]];
	self.deferred = [service :[self params]];
	[self.deferred addCallback:callbackTS(self, successCallback:)];
	[self.deferred addErrback:callbackTS(self, errorCallback:)];
	
	return self;
}


- (void)dealloc {
	callback = nil;
	[target release];
	target = nil;
	self.response = nil;
	self.deferred = nil;
	self.protocol = nil;
	self.serverName = nil;
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
	wasError = NO;
	self.response = results;
	[self requestFinished];
	
	[self processSuccess];
	
	[self requestComplete];
	
	return nil;
}

- (id)errorCallback:(NSError *)err {
	NSLog(@"Error: %@", err);
	NSLog(@"Details: %@", err.userInfo);
	
	wasError = YES;
	handledError = NO;
	self.response = err.userInfo;
	[self requestFinished];

	[self requestComplete];
	
	return nil;
}


- (BOOL)wasError {
	return wasError;
}


- (void)markErrorHandled {
	handledError = YES;
}


- (NSString *)errorMessage {
	return [[self.response objectForKey:@"error"] objectForKey:@"message"];
}


- (NSInteger)errorCode {
	return intv([[self.response objectForKey:@"error"] objectForKey:@"code"]);
}

- (void)requestFinished {
	numRequests--;
	if (numRequests < 1) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
	if (!canceled) {
		[target performSelector:callback withObject:self];

		if (wasError && !handledError) {
			NSString *errorText = [self errorMessage];
			UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Unhandled Error" message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[av show];
		}
	}
}

- (void)cancel {
	canceled = YES;
	[self.deferred cancel];
}


@end
