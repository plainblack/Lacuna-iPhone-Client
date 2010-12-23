//
//  LEEmpireRedefineSpeciesLimits.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/20/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireRedefineSpeciesLimits.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"


@implementation LEEmpireRedefineSpeciesLimits


@synthesize essentiaCost;
@synthesize maxOrbit;
@synthesize minOrbit;
@synthesize minGrowth;
@synthesize can;
@synthesize reason;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	Session *session = [Session sharedInstance];
	return _array(session.sessionId);
}


- (void)processSuccess {
	NSMutableDictionary *result = [self.response objectForKey:@"result"];
	self.essentiaCost = [Util asNumber:[result objectForKey:@"essentia_cost"]];
	self.minOrbit = [Util asNumber:[result objectForKey:@"min_orbit"]];
	self.maxOrbit = [Util asNumber:[result objectForKey:@"max_orbit"]];
	self.minGrowth = [Util asNumber:[result objectForKey:@"min_growth"]];
	self.reason = [result objectForKey:@"reason"];
	self.can = [[result objectForKey:@"can"] boolValue];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"redefine_species_limits";
}


- (void)dealloc {
	self.essentiaCost = nil;
	self.maxOrbit = nil;
	self.minOrbit = nil;
	self.minGrowth = nil;
	self.reason = nil;
	
	[super dealloc];
}


@end
