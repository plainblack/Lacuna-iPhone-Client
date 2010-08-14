//
//  Body.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Body.h"
#import "LEMacros.h"
#import "LEBodyGetBuildings.h"
#import "LEBuildingView.h"
#import "BuildingUtil.h"


@implementation Body


@synthesize id;
@synthesize x;
@synthesize y;
@synthesize starId;
@synthesize starName;
@synthesize orbit;
@synthesize type;
@synthesize name;
@synthesize imageName;
@synthesize size;
@synthesize planetWater;
@synthesize ores;
@synthesize empireId;
@synthesize empireName;
@synthesize alignment;
@synthesize needsSurfaceRefresh;
@synthesize buildingCount;
@synthesize happiness;
@synthesize energy;
@synthesize food;
@synthesize ore;
@synthesize waste;
@synthesize water;
@synthesize buildingMap;
@synthesize surfaceImageName;
@synthesize currentBuilding;
@synthesize needsRefresh;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, type:%@, surfaceImageName:%@, empireId:%@, empireName:%@, x:%i, y:%i, starId:%@i, starName:%@, orbit:%i", 
			self.id, self.name, self.type, self.surfaceImageName, self.empireId, self.empireName, self.x, self.y, self.starId, self.starName, self.orbit];
}


- (void)dealloc {
	self.id = nil;
	self.starId = nil;
	self.starName = nil;
	self.type = nil;
	self.name = nil;
	self.imageName = nil;
	self.ores = nil;
	self.empireId = nil;
	self.empireName = nil;
	self.alignment = nil;
	self.happiness = nil;
	self.energy = nil;
	self.food = nil;
	self.ore = nil;
	self.waste = nil;
	self.water = nil;
	self.buildingMap = nil;
	self.surfaceImageName = nil;
	[self.currentBuilding removeObserver:self forKeyPath:@"needsReload"];
	self.currentBuilding = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark NSObject Methods

- (void)parseData:(NSDictionary *)bodyData {
	self.id = [bodyData objectForKey:@"id"];
	self.x = _intv([bodyData objectForKey:@"x"]);
	self.y = _intv([bodyData objectForKey:@"y"]);
	self.starId = [bodyData objectForKey:@"star_id"];
	self.starName = [bodyData objectForKey:@"star_name"];
	self.orbit = _intv([bodyData objectForKey:@"orbit"]);
	self.type = [[bodyData objectForKey:@"type"] capitalizedString];
	self.name = [bodyData objectForKey:@"name"];
	self.imageName = [bodyData objectForKey:@"image"];
	self.size = _intv([bodyData objectForKey:@"size"]);
	self.planetWater = _intv([bodyData objectForKey:@"water"]);
	self.ores = [bodyData objectForKey:@"ore"];
	NSDictionary *empireData = [bodyData objectForKey:@"empire"];
	self.empireId = [empireData objectForKey:@"id"];
	self.empireName = [empireData objectForKey:@"name"];
	self.alignment = [empireData objectForKey:@"alignment"];
	self.needsSurfaceRefresh = _intv([bodyData objectForKey:@"needs_surface_refresh"]);
	self.buildingCount = _intv([bodyData objectForKey:@"alignment"]);
	if (!self.happiness) {
		self.happiness = [[[NoLimitResource alloc] init] autorelease];
	}
	[self.happiness parseFromData:bodyData withPrefix:@"happiness"];
	if (!self.energy) {
		self.energy = [[[StoredResource alloc] init] autorelease];
	}
	[self.energy parseFromData:bodyData withPrefix:@"energy"];
	if (!self.food) {
		self.food = [[[StoredResource alloc] init] autorelease];
	}
	[self.food parseFromData:bodyData withPrefix:@"food"];
	if (!self.ore) {
		self.ore = [[[StoredResource alloc] init] autorelease];
	}
	[self.ore parseFromData:bodyData withPrefix:@"ore"];
	if (!self.waste) {
		self.waste = [[[StoredResource alloc] init] autorelease];
	}
	[self.waste parseFromData:bodyData withPrefix:@"waste"];
	if (!self.water) {
		self.water = [[[StoredResource alloc] init] autorelease];
	}
	[self.water parseFromData:bodyData withPrefix:@"water"];
	self.needsRefresh = YES;
}


- (void)tick:(NSInteger)interval {
	[self.energy tick:interval];
	[self.food tick:interval];
	[self.happiness tick:interval];
	[self.ore tick:interval];
	NSDecimalNumber *extraWaste = [[[self.waste tick:interval] retain] autorelease];
	[self.water tick:interval];
	
	if (self.currentBuilding) {
		[self.currentBuilding tick:interval];
	}
	
	if (extraWaste) {
		[self.happiness subtractFromCurrent:extraWaste];
	}
}


- (void)loadBuildingMap {
	[[LEBodyGetBuildings alloc] initWithCallback:@selector(buildingMapLoaded:) target:self bodyId:self.id];
}


- (void)loadBuilding:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl {
	[self clearBuilding];
	[[LEBuildingView alloc] initWithCallback:@selector(buildingLoaded:) target:self buildingId:buildingId url:buildingUrl];
}


- (void)clearBuilding {
	[self.currentBuilding removeObserver:self forKeyPath:@"needsReload"];
	self.currentBuilding = nil;
}


#pragma mark --
#pragma mark Callback Methods

- (id)buildingMapLoaded:(LEBodyGetBuildings *)request {
	self.surfaceImageName = request.surfaceImageName;
	self.buildingMap = request.buildings;
	return nil;
}


- (id)buildingLoaded:(LEBuildingView *)request {
	Building *building = [BuildingUtil createBuilding:request];
	[building addObserver:self forKeyPath:@"needsReload" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	self.currentBuilding = building;
	return nil;
}


#pragma mark --
#pragma mark KVO Callback

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"needsReload"]) {
		Building *building = (Building *)object;
		[self loadBuilding:building.id buildingUrl:building.buildingUrl];
	}
}


@end
