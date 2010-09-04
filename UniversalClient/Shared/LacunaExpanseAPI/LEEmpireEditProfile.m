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
#import "EmpireProfile.h"


@implementation LEEmpireEditProfile


@synthesize profile;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget textKey:(NSString *)textKey text:(NSString *)text empire:(EmpireProfile *)empire {
	self.profile = [NSMutableDictionary dictionaryWithCapacity:3];
	[self.profile setObject:empire.status forKey:@"status_message"];
	[self.profile setObject:empire.description forKey:@"description"];
	[self.profile setObject:[NSArray array] forKey:@"public_medals"];
	[self.profile setObject:text forKey:textKey];
	return [super initWithCallback:inCallback target:inTarget];
}


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget medals:(NSArray *)inMedals {
	NSMutableArray *publicMedals = [NSMutableArray arrayWithCapacity:[inMedals count]];
	
	[inMedals enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		if (_boolv([obj objectForKey:@"public"])) {
			[publicMedals addObject:[obj objectForKey:@"id"]];
		}
	}];
	self.profile = [NSMutableDictionary dictionaryWithCapacity:1];
	[self.profile setObject:publicMedals forKey:@"public_medals"];
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, profile);
}


- (void)processSuccess {
	//NSDictionary *result = [self.response objectForKey:@"result"];
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
