//
//  LERenameBody.m
//  DKTest
//
//  Created by Kevin Runde on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LERenameBody.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LERenameBody


@synthesize bodyId = _bodyId;
@synthesize bodyName = _bodyName;
@synthesize result = _result;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget forBody:(NSString *)inBodyId newName:(NSString *)bodyName {
	self.bodyId = inBodyId;
	self.bodyName = bodyName;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}

- (id)params {
	return _array([Session sharedInstance].sessionId, self.bodyId, self.bodyName);
}


- (void)processSuccess {
	self.result = [self.response objectForKey:@"result"];
	
}


- (NSString *)serviceUrl {
	return @"body";
}


- (NSString *)methodName {
	return @"rename";
}


- (void)dealloc {
	self.bodyId = nil;
	self.bodyName = nil;
	self.result = nil;
	[super dealloc];
}


@end
