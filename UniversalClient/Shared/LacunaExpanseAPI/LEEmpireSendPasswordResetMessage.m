//
//  LEEmpireSendPasswordResetMessage.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireSendPasswordResetMessage.h"
#import "LEMacros.h"


@implementation LEEmpireSendPasswordResetMessage


@synthesize empireId;
@synthesize empireName;
@synthesize emailAddress;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget empireId:(NSString *)inEmpireId empireName:(NSString *)inEmpireName emailAddress:(NSString *)inEmailAddress {
	self.empireId = inEmpireId;
	self.empireName = inEmpireName;
	self.emailAddress = inEmailAddress;
	
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
	
	if (self.empireId && [self.empireId length] > 0) {
		[params setObject:self.empireId forKey:@"empire_id"];
	}
	if (self.empireName && [self.empireName length] > 0) {
		[params setObject:self.empireName forKey:@"empire_name"];
	}
	if (self.emailAddress && [self.emailAddress length] > 0) {
		[params setObject:self.emailAddress forKey:@"email"];
	}

	NSLog(@"Send Password Reset Message params: %@", params);
	return params;
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSLog(@"Send Password Reset Message response: %@", self.response);
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"send_password_reset_message";
}


- (void)dealloc {
	self.empireId = nil;
	self.empireName = nil;
	self.emailAddress = nil;
	[super dealloc];
}


@end
