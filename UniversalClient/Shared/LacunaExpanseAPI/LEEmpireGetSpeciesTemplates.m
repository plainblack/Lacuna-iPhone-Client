//
//  LEEmpireGetSpeciesTemplates.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEEmpireGetSpeciesTemplates.h"
#import "Session.h"
#import "LEMacros.h"
#import "Util.h"


@implementation LEEmpireGetSpeciesTemplates


@synthesize templates;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget {
	return [super initWithCallback:inCallback target:inTarget];
}


- (id)params {
	return [NSArray array];
}


- (void)processSuccess {
	self.templates = [self.response objectForKey:@"result"];
}


- (NSString *)serviceUrl {
	return @"empire";
}


- (NSString *)methodName {
	return @"get_species_templates";
}


- (void)dealloc {
	self.templates = nil;
	[super dealloc];
}


@end
