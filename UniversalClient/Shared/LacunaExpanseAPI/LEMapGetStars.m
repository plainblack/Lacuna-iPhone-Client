//
//  LEMapGetStars.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEMapGetStars.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEMapGetStars


@synthesize topLeftX;
@synthesize topLeftY;
@synthesize bottomRightX;
@synthesize bottomRightY;
@synthesize stars;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget topLeftX:(NSDecimalNumber *)inTopLeftX topLeftY:(NSDecimalNumber *)inTopLeftY bottomRightX:(NSDecimalNumber *)inBottomRightX bottomRightY:(NSDecimalNumber *)inBottomRightY {
	self.topLeftX = inTopLeftX;
	self.topLeftY = inTopLeftY;
	self.bottomRightX = inBottomRightX;
	self.bottomRightY = inBottomRightY;
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId, self.topLeftX, self.topLeftY, self.bottomRightX, self.bottomRightY);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.stars = [result objectForKey:@"stars"];
}


- (NSString *)serviceUrl {
	return @"map";
}


- (NSString *)methodName {
	return @"get_stars";
}


- (void)dealloc {
	self.topLeftX = nil;
	self.topLeftY = nil;
	self.bottomRightX = nil;
	self.bottomRightY = nil;
	self.stars = nil;
	[super dealloc];
}


@end
