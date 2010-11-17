//
//  BuildingUtil.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BuildingUtil.h"
#import "LEBuildingView.h"
#import "BaseTradeBuilding.h"
#import "Building.h"
#import "Archaeology.h"
#import "Capitol.h"
#import "Development.h"
#import "Embassy.h"
#import "Entertainment.h"
#import "FoodReserve.h"
#import "Intelligence.h"
#import "MiningMinistry.h"
#import "MissionCommand.h"
#import "Network19.h"
#import "Observatory.h"
#import "OreStorage.h"
#import "Park.h"
#import "PlanetaryCommand.h"
#import "Security.h"
#import "Shipyard.h"
#import "SpacePort.h"
#import "TempleOfTheDrajilites.h"
#import "WasteRecycling.h"


@implementation BuildingUtil


+ (Building *)createBuilding:(LEBuildingView *)request {
	Building *building = nil;
	if ([request.buildingUrl isEqualToString:ARCHAEOLOGY_URL]) {
		building = [[[Archaeology alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:CAPITOL_URL]) {
		building = [[[Capitol alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:DEVELOPMENT_URL]) {
		building = [[[Development alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:EMBASSY_URL]) {
		building = [[[Embassy alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:ENTERTAINMENT_URL]) {
		building = [[[Entertainment alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:FOOD_RESERVE_URL]) {
		building = [[[FoodReserve alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:INTELLIGENCE_URL]) {
		building = [[[Intelligence alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:MINING_MINISTRY_URL]) {
		building = [[[MiningMinistry alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:MISSION_COMMAND_URL]) {
		building = [[[MissionCommand alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:NETWORK_19_URL]) {
		building = [[[Network19 alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:OBSERVATORY_URL]) {
		building = [[[Observatory alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:ORE_STORAGE_URL]) {
		building = [[[OreStorage alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:PARK_URL]) {
		building = [[[Park alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:PLANETARY_COMMAND_URL]) {
		building = [[[PlanetaryCommand alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:SECURITY_URL]) {
		building = [[[Security alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:SPACE_PORT_URL]) {
		building = [[[SpacePort alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:SHIPYARD_URL]) {
		building = [[[Shipyard alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:TEMPLE_OF_THE_DRAJILITEIS_URL]) {	
		building = [[[TempleOfTheDrajilites alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:TRADE_URL]) {
		building = [[[BaseTradeBuilding alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:TRANSPORTER_URL]) {
		building = [[[BaseTradeBuilding alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:WASTE_RECYCLING_URL]) {
		building = [[[WasteRecycling alloc] init] autorelease];
	} else {
		building = [[[Building alloc] init] autorelease];
	}
	
	building.buildingUrl = request.buildingUrl;
	[building parseData:request.result];
	return building;
}


@end
