//
//  LEGetBuildings.m
//  DKTest
//
//  Created by Kevin Runde on 3/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LEBodyGetBuildings.h"
#import "Session.h"
#import "LEMacros.h"


@implementation LEBodyGetBuildings


@synthesize bodyId;
@synthesize buildings;
@synthesize surfaceImageName;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget bodyId:(NSString *)inBodyId {
	self.bodyId = inBodyId;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return array_([Session sharedInstance].sessionId, self.bodyId);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	
	NSDictionary *buildingsDict = [result objectForKey:@"buildings"];
	self.buildings = [NSMutableDictionary dictionaryWithCapacity:[buildingsDict count]];
	
	self.surfaceImageName = [[result objectForKey:@"body"] objectForKey:@"surface_image"];
	
	for(NSString *buildingId in [buildingsDict allKeys]) {
		NSMutableDictionary *building = [buildingsDict objectForKey:buildingId];
		[building setObject:buildingId forKey:@"id"];
		NSString *location = [NSString stringWithFormat:@"%@x%@", [building objectForKey:@"x"], [building objectForKey:@"y"]];
		[self.buildings setObject:building forKey:location];
	}
}


- (NSString *)serviceUrl {
	return @"body";
}


- (NSString *)methodName {
	return @"get_buildings";
}


- (void)dealloc {
	self.bodyId = nil;
	self.buildings = nil;
	self.surfaceImageName = nil;
	[super dealloc];
}


@end
