//
//  LERequest.m
//  DKTest
//
//  Created by Kevin Runde on 2/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LERequest.h"
#import "JSON.h"
#import "Session.h"
#import "LEMacros.h"
#import "AppDelegate_Phone.h"


static int numRequests = 0;
static id<LERequestMonitor> delegate;


@interface LERequest (PrivateMethods)

- (void)sendRequest;
- (void)requestComplete;
- (void)requestFinished;

@end

	
@implementation LERequest


@synthesize response;
@synthesize conn;
@synthesize receivedData;


- (id)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
    self = [super init];
    if (self) {
        self->canceled = NO;
        self->wasError = NO;
        self->handledError = NO;
        self->retryCount = 0;
        
        self->callback = inCallback;
        self->target = inTarget;
        
        [self->target retain];
        
        numRequests++;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self sendRequest];
    }
	
	return self;
}


- (void)dealloc {
	self->callback = nil;
	[self->target release];
	self->target = nil;
	self.response = nil;
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
	if (err.code == -1009) {
		//Network appears to be offline so retry.
		if (self->retryCount < 2) {
			[self performSelector:@selector(sendRequest) withObject:nil afterDelay:1];
			self->retryCount++;
			return nil;
		} else {
			self.response = _dict(_dict(@"Could not connect to server.", @"message"), @"error");
		}
	} else {
		self.response = err.userInfo;
	}


	if ([self errorCode] == 1017) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Vote Required" message:[self errorMessage] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];

		[self requestFinished];
		[self requestComplete];
    } else {
        self->wasError = YES;
        self->handledError = NO;

        if ([self errorCode] == 1006) {
            Session *session = [Session sharedInstance];
            [session reloginTarget:self selector:@selector(resend)];
        } else if ([self errorCode] == 1200) {
            [self requestFinished];
            
            AppDelegate_Phone *appDelegate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
            NSLog(@"Error Data: %@", [self errorData]);
            [appDelegate gameover:(NSString *)[self errorData]];
        } else if ([self errorCode] == 1016) {
            AppDelegate_Phone *appDelegate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
            [appDelegate captchaValidate:self];
        } else {
            NSLog(@"For Request: %@", self.class);
            NSLog(@"Error: %@", err);
            NSLog(@"Details: %@", err.userInfo);
            
            [self requestFinished];
            [self requestComplete];
        }
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

- (NSMutableDictionary *)errorData {
	return [[self.response objectForKey:@"error"] objectForKey:@"data"];
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
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		if (!self->canceled) {
			[self->target performSelector:self->callback withObject:self];
			
			if (wasError && !handledError) {
				NSString *errorText = [self errorMessage];
				if ([errorText isEqualToString:@"Internal error."]) {
					errorText = @"Your request could be not be completed due to a server error.";
				}
				
				UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message:errorText preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [av dismissViewControllerAnimated:YES completion:nil]; }];
				[av addAction: ok];
			}
		}
		
		NSDictionary *result = [self.response objectForKey:@"result"];
		if (result && [result respondsToSelector:@selector(objectForKey:)]) {
			NSDictionary *status = [result objectForKey:@"status"];
			if (status) {
				NSDictionary *serverStatus = [status objectForKey:@"server"];
				NSString *announcementValue = [serverStatus objectForKey:@"announcement"];
				if (isNotNull(announcementValue)) {
					if (_intv(announcementValue) > 0) {
						AppDelegate_Phone *appDelegate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
						[appDelegate showAnnouncement];
					}
				}
			}
		}
	}];
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
	//NSLog(@"Calling: %@", url);
	
	NSDictionary *methodCall = _dict([self methodName], @"method", 
									 [self params], @"params", 
									 [LERequest stringWithUUID], @"id", 
									 @"1.1", @"version");
	
	NSError *error = NULL;
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];
	NSString *jsonString = [writer stringWithObject:methodCall error:&error];
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	[writer release];
	if (!jsonData && error) {
		[self errorCallback:error];
	} else {
		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0 ] autorelease];
		[request setTimeoutInterval:600.0];
		[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
		[request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
		[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		[request setValue:@"TLE iOS Client" forHTTPHeaderField:@"User-Agent"];
		[request setHTTPMethod:@"POST"];
		[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
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
	[self errorCallback:[NSError errorWithDomain:@"LERequest" code:2 userInfo:_dict(@"LERequest Canceled", @"reason")]];
}


+ (void)setDelegate:(id<LERequestMonitor>)inDelegate {
	delegate = inDelegate;
}


+ (NSInteger)getCurrentRequestCount {
	return numRequests;
}


- (void)resend {
	[self sendRequest];
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
	NSError *error = nil;
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSMutableDictionary *results = [parser objectWithString:jsonString error:&error];
	[parser release];
	//NSLog(@"results: %@", results);
	//NSLog(@"error: %@", error);
	self.conn = nil;
	self.receivedData = nil;
	
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
