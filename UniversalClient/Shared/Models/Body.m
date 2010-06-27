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
	[super dealloc];
}


#pragma mark --
#pragma mark NSObject Methods

- (void)parseData:(NSDictionary *)bodyData {
	self.id = [bodyData objectForKey:@"id"];
	self.x = intv_([bodyData objectForKey:@"x"]);
	self.y = intv_([bodyData objectForKey:@"y"]);
	self.starId = [bodyData objectForKey:@"star_id"];
	self.starName = [bodyData objectForKey:@"star_name"];
	self.orbit = intv_([bodyData objectForKey:@"orbit"]);
	self.type = [bodyData objectForKey:@"id"];
	self.name = [bodyData objectForKey:@"name"];
	self.imageName = [bodyData objectForKey:@"image"];
	self.size = intv_([bodyData objectForKey:@"size"]);
	self.planetWater = intv_([bodyData objectForKey:@"water"]);
	self.ores = [bodyData objectForKey:@"ores"];
	NSDictionary *empireData = [bodyData objectForKey:@"empire"];
	self.empireId = [empireData objectForKey:@"id"];
	self.empireName = [empireData objectForKey:@"name"];
	self.alignment = [empireData objectForKey:@"alignment"];
	self.needsSurfaceRefresh = intv_([bodyData objectForKey:@"needs_surface_refresh"]);
	self.buildingCount = intv_([bodyData objectForKey:@"alignment"]);
	self.happiness = [NoLimitResource createFromData:bodyData withPrefix:@"happiness"];
	self.energy = [StoredResource createFromData:bodyData withPrefix:@"energy"];
	self.food = [StoredResource createFromData:bodyData withPrefix:@"food"];
	self.ore = [StoredResource createFromData:bodyData withPrefix:@"ore"];
	self.waste = [StoredResource createFromData:bodyData withPrefix:@"waste"];
	self.water = [StoredResource createFromData:bodyData withPrefix:@"water"];
	NSLog(@"Parsed Body: %@", self);
}


- (void)tick:(NSTimeInterval)interval {
	[self.energy tick:interval];
	[self.food tick:interval];
	[self.happiness tick:interval];
	[self.ore tick:interval];
	NSNumber *extraWaste = [[[self.waste tick:interval] retain] autorelease];
	[self.water tick:interval];
	
	if (extraWaste) {
		[self.happiness subtractFromCurrent:extraWaste];
	}
}


- (void)loadBuildingMap {
	NSLog(@"loadBuildingMap called");
	[[LEBodyGetBuildings alloc] initWithCallback:@selector(buildingMapLoaded:) target:self bodyId:self.id];
}


#pragma mark --
#pragma mark Callback Methods

- (id)buildingMapLoaded:(LEBodyGetBuildings *)request {
	NSLog(@"buildingMapLoaded: %@", request);
	self.surfaceImageName = request.surfaceImageName;
	self.buildingMap = request.buildings;
	return nil;
}




@end
