//
//  LEBuildingGetBuildableShips.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetBuildableShips.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "BuildableShip.h"


@implementation LEBuildingGetBuildableShips


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize buildableShips;
@synthesize docksAvailable;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.docksAvailable = [Util asNumber:[result objectForKey:@"docks_available"]];
	
	NSMutableDictionary *shipsTravellingData = [result objectForKey:@"buildable"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[shipsTravellingData count]];
	[shipsTravellingData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[obj setObject:key forKey:@"type"];
		BuildableShip *buildableShip = [[[BuildableShip alloc] init] autorelease];
		[buildableShip parseData:obj];
		
		[tmp addObject:buildableShip];
	}];
	[tmp sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease])];
	self.buildableShips	= tmp;
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_buildable";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.buildableShips = nil;
	self.docksAvailable = nil;
	[super dealloc];
}


@end
