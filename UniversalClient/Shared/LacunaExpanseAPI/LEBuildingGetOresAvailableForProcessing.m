//
//  LEBuildingGetOresAvailableForProcessing.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LEBuildingGetOresAvailableForProcessing.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingGetOresAvailableForProcessing


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize oreTypes;


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
	NSDictionary *oreData = [result objectForKey:@"ore"];
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[oreData count]];
	
	[oreData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[tmp addObject:_dict(key, @"type", obj, @"amount")];
	}];
	
	[tmp sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES])];
	
	self.oreTypes = tmp;
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"get_ores_available_for_processing";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.oreTypes = nil;
	[super dealloc];
}


@end
