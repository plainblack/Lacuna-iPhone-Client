//
//  LEBuildingViewBattleReport.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/7/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingViewBattleReport.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Ship.h"


@implementation LEBuildingViewBattleReport


@synthesize buildingId;
@synthesize buildingUrl;
@synthesize pageNumber;
@synthesize battleLogs;
@synthesize numberOfBattleLogs;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget buildingId:(NSString *)inBuildingId buildingUrl:(NSString *)inBuildingUrl pageNumber:(NSInteger)inPageNumber {
	self.buildingId = inBuildingId;
	self.buildingUrl = inBuildingUrl;
	self.pageNumber = inPageNumber;
	return [self initWithCallback:inCallback target:(NSObject *)inTarget];
}


- (id)params {
	return _array([Session sharedInstance].sessionId, self.buildingId, [NSDecimalNumber numberWithInt:self.pageNumber]);
}


- (void)processSuccess {
	NSDictionary *result = [self.response objectForKey:@"result"];
	self.numberOfBattleLogs = [Util asNumber:[result objectForKey:@"number_of_logs"]];
	self.battleLogs = [result objectForKey:@"battle_log"];
}


- (NSString *)serviceUrl {
	return self.buildingUrl;
}


- (NSString *)methodName {
	return @"view_battle_logs";
}


- (void)dealloc {
	self.buildingId = nil;
	self.buildingUrl = nil;
	self.battleLogs = nil;
	self.numberOfBattleLogs = nil;
	[super dealloc];
}
@end
