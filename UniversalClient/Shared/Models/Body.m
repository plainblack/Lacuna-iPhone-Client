//
//  Body.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Body.h"
#import "LEMacros.h"
#import "Session.h"
#import "Util.h"
#import "BuildingUtil.h"
#import "MapBuilding.h"
#import "LEBodyGetBuildings.h"
#import "LEBuildingView.h"


@implementation Body


@synthesize starId;
@synthesize starName;
@synthesize orbit;
@synthesize imageName;
@synthesize size;
@synthesize plotsAvailable;
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
@synthesize incomingForeignShips;
@synthesize ignoreIncomingForeignShipData;
@dynamic isPlanet;
@dynamic isSpaceStation;
@synthesize allianceId;
@synthesize allianceName;
@synthesize influenceTotal;
@synthesize influenceSpent;
@synthesize population;


#pragma mark -
#pragma mark NSObject Methods

- (id)init {
    if ((self = [super init])) {
		self.ignoreIncomingForeignShipData = NO;
	}
	
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, type:%@, surfaceImageName:%@, empireId:%@, empireName:%@, x:%@, y:%@, starId:%@, starName:%@, orbit:%@, buildingCount:%@, needsSurfaceRefresh:%i, incomingForeignShips:%@, planetWater: %@, ores:%@, stationId:%@, stationName:%@, stationX:%@, stationY:%@, allianceId:%@, allianceName:%@, influenceTotal:%@, influenceSpent:%@, population:%@",
			self.id, self.name, self.type, self.surfaceImageName, self.empireId, self.empireName, self.x, self.y, self.starId, self.starName, self.orbit, self.buildingCount, self.needsSurfaceRefresh, self.incomingForeignShips, self.planetWater, self.ores, self.stationId, self.stationName, self.stationX, self.stationY, self.allianceId, self.allianceName, self.influenceTotal, self.influenceSpent, self.population];
}


- (void)dealloc {
	self.starId = nil;
	self.starName = nil;
	self.orbit = nil;
	self.imageName = nil;
	self.size = nil;
	self.plotsAvailable = nil;
	self.planetWater = nil;
	self.ores = nil;
	self.empireId = nil;
	self.empireName = nil;
	self.alignment = nil;
	self.buildingCount = nil;
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
	self.incomingForeignShips = nil;
    self.allianceId = nil;
    self.allianceName = nil;
    self.influenceTotal = nil;
    self.influenceSpent = nil;
    self.population = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (BOOL)isPlanet {
    return ([self.type isEqualToString:@"gas giant"] || [self.type isEqualToString:@"habitable planet"]);
}


- (BOOL)isSpaceStation {
    return ([self.type isEqualToString:@"space station"]);
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSMutableDictionary *)bodyData {
	[super parseData:bodyData];
	self.starId = [bodyData objectForKey:@"star_id"];
	self.starName = [bodyData objectForKey:@"star_name"];
	self.orbit = [Util asNumber:[bodyData objectForKey:@"orbit"]];
	self.imageName = [bodyData objectForKey:@"image"];
	self.size = [Util asNumber:[bodyData objectForKey:@"size"]];
	self.plotsAvailable = [Util asNumber:[bodyData objectForKey:@"plots_available"]];
    if (isNull(self.plotsAvailable)) {
        self.plotsAvailable = [NSDecimalNumber zero];
    }
	self.planetWater = [Util asNumber:[bodyData objectForKey:@"water"]];
	self.ores = [bodyData objectForKey:@"ore"];
	NSDictionary *empireData = [bodyData objectForKey:@"empire"];
	self.empireId = [Util idFromDict:empireData named:@"id"];
	self.empireName = [empireData objectForKey:@"name"];
	self.alignment = [empireData objectForKey:@"alignment"];
	self.needsSurfaceRefresh = _boolv([bodyData objectForKey:@"needs_surface_refresh"]);
	self.buildingCount = [Util asNumber:[bodyData objectForKey:@"building_count"]];
    self.population = [Util asNumber:[bodyData objectForKey:@"population"]];
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
	
	if (self.ignoreIncomingForeignShipData) {
		self.incomingForeignShips = nil;
	} else {
		NSMutableArray *incomingForeignShipData = [bodyData objectForKey:@"incoming_foreign_ships"];
		if (isNotNull(incomingForeignShipData)) {
			NSMutableDictionary *dateStringToData = [NSMutableDictionary dictionaryWithCapacity:[incomingForeignShipData count]];
			NSMutableSet *newSet = [NSMutableSet setWithCapacity:[incomingForeignShipData count]];
			for (NSMutableDictionary *tmp in incomingForeignShipData) {
				NSString *dateString = [tmp objectForKey:@"date_arrives"];
				[newSet addObject:dateString];
				[dateStringToData setObject:tmp forKey:dateString];
			}
			NSMutableSet *warnAboutSet;
			warnAboutSet = [newSet mutableCopy];
			if (self.incomingForeignShips) {
				[warnAboutSet minusSet:self.incomingForeignShips];
			}
			__block NSUInteger numOwnShips = 0;
			__block NSUInteger numAllyShips = 0;
			__block NSUInteger numOtherShips = 0;
			[warnAboutSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop){
				NSMutableDictionary *tmp = [dateStringToData objectForKey:obj];
				BOOL isOwn = [[tmp objectForKey:@"is_own"] boolValue];
				BOOL isAlly = [[tmp objectForKey:@"is_ally"] boolValue];
				if (isOwn) {
					numOwnShips++;
				} else if (isAlly) {
					numAllyShips++;
				} else {
					numOtherShips++;
				}
			}];
			if (numOtherShips > 0) {
				UIAlertController *av = [UIAlertController alertControllerWithTitle:@"INCOMING SHIPS!" message: @"Incoming ships detected. Go to your Spaceport for more information." preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [av dismissViewControllerAnimated:YES completion:nil]; }];
				[av addAction: ok];
			} else if (numAllyShips) {
				UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Ally ships incoming" message: @"Incoming ally ships detected. Go to your Spaceport for more information." preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [av dismissViewControllerAnimated:YES completion:nil]; }];
				[av addAction: ok];
			}

			[warnAboutSet release];
			self.incomingForeignShips = newSet;
		} else {
			if (self.incomingForeignShips) {
				self.incomingForeignShips = nil;
			}
		}
	}
    
    NSMutableDictionary *allianceData = [bodyData objectForKey:@"alliance"];
    if (isNotNull(allianceData)) {
        self.allianceId = [Util idFromDict:allianceData named:@"id"];
        self.allianceName = [allianceData objectForKey:@"name"];
    } else {
        self.allianceId = nil;
        self.allianceName = nil;
    }
    
    NSMutableDictionary *influenceData = [bodyData objectForKey:@"influence"];
    if (isNotNull(influenceData)) {
        self.influenceTotal = [Util asNumber:[influenceData objectForKey:@"total"]];
        self.influenceSpent = [Util asNumber:[influenceData objectForKey:@"spent"]];
    } else {
        self.influenceTotal = nil;
        self.influenceSpent = nil;
    }
	
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
		if ([self.currentBuilding tick:interval]) {
			self.currentBuilding.needsReload = YES;
		}
	}
	
	if (extraWaste) {
		[self.happiness subtractFromCurrent:extraWaste];
	}

	[self.buildingMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		MapBuilding *mapBuilding = obj;
		[mapBuilding tick:interval];
		if (mapBuilding.needsReload) {
			[self loadBuildingMap];
		}
	}];
	
	self.needsRefresh = YES;
}


- (void)loadBuildingMap {
	[[[LEBodyGetBuildings alloc] initWithCallback:@selector(buildingMapLoaded:) target:self bodyId:self.id] autorelease];
}


- (void)loadBuilding:(NSString *)buildingId buildingUrl:(NSString *)buildingUrl {
	[self clearBuilding];

	[[[LEBuildingView alloc] initWithCallback:@selector(buildingLoaded:) target:self buildingId:buildingId url:buildingUrl] autorelease];
}


- (void)clearBuilding {
	[self.currentBuilding removeObserver:self forKeyPath:@"needsReload"];
	self.currentBuilding = nil;
}


#pragma mark -
#pragma mark Callback Methods

- (id)buildingMapLoaded:(LEBodyGetBuildings *)request {
	self.surfaceImageName = request.surfaceImageName;
	//self.buildingMap = request.buildings;
	NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithCapacity:[request.buildings count]];
	
	[request.buildings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		MapBuilding *mapBuilding = [[MapBuilding alloc] init];
		[mapBuilding parseData:obj];
		[tmp setObject:mapBuilding forKey:key];
		[mapBuilding release];
	}];
	self.buildingMap = tmp;

	return nil;
}


- (id)buildingLoaded:(LEBuildingView *)request {
	Building *building = [BuildingUtil createBuilding:request];
	[building addObserver:self forKeyPath:@"needsReload" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	self.currentBuilding = building;
	return nil;
}


#pragma mark -
#pragma mark KVO Callback

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"needsReload"]) {
		Building *building = (Building *)object;
		[self loadBuilding:building.id buildingUrl:building.buildingUrl];
	}
}


@end
