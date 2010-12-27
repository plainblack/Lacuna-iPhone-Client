//
//  BuildableShip.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BuildableShip.h"
#import "LEMacros.h"


@implementation BuildableShip


@synthesize type;
@synthesize canBuild;
@synthesize reason;
@synthesize buildCost;
@synthesize attributes;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"type:%@, canBuild:%i, reason:%@, buildCost:%@, attributes:%@", 
			self.type, self.canBuild, self.reason, self.buildCost, self.attributes];
}


- (void)dealloc {
	self.type = nil;
	self.reason = nil;
	self.buildCost = nil;
	self.attributes = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)buildableShipData {
	NSLog(@"Buildable Ship Data: %@", buildableShipData);
	self.type = [buildableShipData objectForKey:@"type"];
	self.canBuild = _boolv([buildableShipData objectForKey:@"can"]);
	self.reason = [buildableShipData objectForKey:@"reason"];
	
	if (!self.buildCost) {
		self.buildCost = [[[ResourceCost alloc] init] autorelease];
	}
	NSDictionary *buildCostData = [buildableShipData objectForKey:@"cost"];
	[self.buildCost parseData:buildCostData];

	self.attributes = [buildableShipData objectForKey:@"attributes"];
}


@end
