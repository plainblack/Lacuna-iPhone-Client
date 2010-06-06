//
//  LEEmpireEditProfile.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireEditProfile.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEEmpireEditProfile


@synthesize profile;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget textKey:(NSString *)textKey text:(NSString *)text leEmpireViewProfile:(LEEmpireViewProfile *)leEmpireViewProfile {
	self.profile = [NSMutableDictionary dictionaryWithCapacity:3];
	[self.profile setObject:leEmpireViewProfile.status forKey:@"status_message"];
	[self.profile setObject:leEmpireViewProfile.description forKey:@"description"];
	[self.profile setObject:[NSArray array] forKey:@"public_medals"];
	[self.profile setObject:text forKey:textKey];
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return array_(session.sessionId, profile);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	NSLog(@"Result: %@", result);
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"edit_profile";
}


- (void)dealloc {
	self.profile = nil;
	[super dealloc];
}


@end
