//
//  MapBuilding.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "MapBuilding.h"
#import "LEMacros.h"
#import "Util.h"


@implementation MapBuilding


@synthesize id;
@synthesize buildingUrl;
@synthesize name;
@synthesize imageName;
@synthesize level;
@synthesize x;
@synthesize y;
@synthesize efficiency;
@synthesize pendingBuild;
@synthesize work;
@synthesize needsRefresh;
@synthesize needsReload;
@synthesize image;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, buildingUrl:%@, name:%@, imageName:%@, level:%@, x:%@, y:%@, efficency:%@, pendingBuild:%@, work:%@",
			self.id, self.buildingUrl, self.name, self.imageName, self.level, self.x, self.y, self.efficiency, self.pendingBuild, self.work];
}

- (void)dealloc {
	self.id = nil;
	self.buildingUrl = nil;
	self.name = nil;
	self.imageName = nil;
	self.level = nil;
	self.x = nil;
	self.y = nil;
	self.efficiency = nil;
	self.pendingBuild = nil;
	self.work = nil;
	self.image = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.id = [Util idFromDict:data named:@"id"];
	self.buildingUrl = [data objectForKey:@"url"];
	self.name = [data objectForKey:@"name"];
	self.imageName = [data objectForKey:@"image"];
	self.image = [UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", self.imageName]];
	self.level = [Util asNumber:[data objectForKey:@"level"]];
	self.x = [Util asNumber:[data objectForKey:@"x"]];
	self.y = [Util asNumber:[data objectForKey:@"y"]];
	
	NSDictionary *pendingBuildDict = [data objectForKey:@"pending_build"]; 
	if (isNotNull(pendingBuildDict)) {
		if(!self.pendingBuild) {
			self.pendingBuild = [[[TimedActivity alloc] init] autorelease];
		}
		[self.pendingBuild parseData:pendingBuildDict];
	} else {
		self.pendingBuild = nil;
	}
	
	NSDictionary *workBuildDict = [data objectForKey:@"work"];
	if (isNotNull(workBuildDict)) {
		if(!self.work) {
			self.work = [[[TimedActivity alloc] init] autorelease];
		}
		[self.work parseData:[data objectForKey:@"work"]];
	} else {
		self.work = nil;
	}
	
	self.efficiency = [Util asNumber:[data objectForKey:@"efficiency"]];
}


- (void)tick:(NSInteger)interval {
	[self.pendingBuild tick:interval];
	if (self.pendingBuild && self.pendingBuild.secondsRemaining <= 0) {
		self.pendingBuild = nil;
		self.needsReload = YES;
	}
	
	[self.work tick:interval];
	if (self.work && self.work.secondsRemaining <= 0) {
		self.work = nil;
	}
	self.needsRefresh = YES;
}


- (void)updatePendingBuild:(NSDictionary *)pendingBuildData {
	if (!self.pendingBuild) {
		self.pendingBuild = [[[TimedActivity alloc] init] autorelease];
	}
	[self.pendingBuild parseData:pendingBuildData];
	self.needsRefresh = YES;
}


- (void)updateWork:(NSDictionary *)workData {
	if (!self.work) {
		self.work = [[[TimedActivity alloc] init] autorelease];
	}
	[self.work parseData:workData];
	self.needsRefresh = YES;
}


- (void)repaired {
	self.efficiency = [NSDecimalNumber decimalNumberWithString:@"100"];
	self.needsRefresh;
}


@end
