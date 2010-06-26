//
//  Empire.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "EmpireProfile.h"


@implementation EmpireProfile


@synthesize description;
@synthesize status;
@synthesize medals;


- (void)dealloc {
	self.description = nil;
	self.status = nil;
	self.medals = nil;
	[super dealloc];
}


@end
