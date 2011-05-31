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
#import "DistributionCenter.h"
#import "Embassy.h"
#import "EnergyReserve.h"
#import "Entertainment.h"
#import "FoodReserve.h"
#import "GeneticsLab.h"
#import "HallsOfVrbansk.h"
#import "Intelligence.h"
#import "LibraryOfJith.h"
#import "MercenariesGuild.h"
#import "MiningMinistry.h"
#import "MissionCommand.h"
#import "Network19.h"
#import "Observatory.h"
#import "OracleOfAnid.h"
#import "OreStorage.h"
#import "Park.h"
#import "PlanetaryCommand.h"
#import "Security.h"
#import "Shipyard.h"
#import "SpacePort.h"
#import "SpaceStationLabA.h"
#import "SubspaceSupplyDepot.h"
#import "TempleOfTheDrajilites.h"
#import "ThemePark.h"
#import "WasteRecycling.h"
#import "WaterStorage.h"

#import "SpyTraining.h"

#import "Module.h"
#import "Parliament.h"
#import "PoliceStation.h"
#import "StationCommand.h"


@implementation BuildingUtil


+ (Building *)createBuilding:(LEBuildingView *)request {
	Building *building = nil;
	if ([request.buildingUrl isEqualToString:ARCHAEOLOGY_URL]) {
		building = [[[Archaeology alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:CAPITOL_URL]) {
		building = [[[Capitol alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:DEVELOPMENT_URL]) {
		building = [[[Development alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:DISTRIBUTION_CENTER_URL]) {
		building = [[[DistributionCenter alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:EMBASSY_URL]) {
		building = [[[Embassy alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:ENERGY_RESERVE_URL]) {
		building = [[[EnergyReserve alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:ENTERTAINMENT_URL]) {
		building = [[[Entertainment alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:FOOD_RESERVE_URL]) {
		building = [[[FoodReserve alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:GENETICS_LAB_URL]) {
		building = [[[GeneticsLab alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:HALLS_OF_VRBANSK]) {
		building = [[[HallsOfVrbansk alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:INTELLIGENCE_URL]) {
		building = [[[Intelligence alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:LIBRARY_OF_JITH_URL]) {
		building = [[[LibraryOfJith alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:MERCENARIES_GUILD_URL]) {
		building = [[[MercenariesGuild alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:MINING_MINISTRY_URL]) {
		building = [[[MiningMinistry alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:MISSION_COMMAND_URL]) {
		building = [[[MissionCommand alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:NETWORK_19_URL]) {
		building = [[[Network19 alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:OBSERVATORY_URL]) {
		building = [[[Observatory alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:ORACLE_OF_ANID_URL]) {
		building = [[[OracleOfAnid alloc] init] autorelease];
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
	} else if ([request.buildingUrl isEqualToString:SPACE_STATION_LAB_A]) {
		building = [[[SpaceStationLabA alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:SHIPYARD_URL]) {
		building = [[[Shipyard alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:SUBSPACE_SUPPLY_DEPOT_URL]) {
		building = [[[SubspaceSupplyDepot alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:TEMPLE_OF_THE_DRAJILITEIS_URL]) {	
		building = [[[TempleOfTheDrajilites alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:THEME_PARK_URL]) {	
		building = [[[ThemePark alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:TRADE_URL]) {
		building = [[[BaseTradeBuilding alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:TRANSPORTER_URL]) {
		building = [[[BaseTradeBuilding alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:WASTE_EXCHANGER_URL]) {
		building = [[[WasteRecycling alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:WASTE_RECYCLING_URL]) {
		building = [[[WasteRecycling alloc] init] autorelease];
	} else if ([request.buildingUrl isEqualToString:WATER_STORAGE_URL]) {
		building = [[[WaterStorage alloc] init] autorelease];
    } else if ([request.buildingUrl isEqualToString:IBS_URL]) {
		building = [[[Module alloc] init] autorelease];

    } else if ([request.buildingUrl isEqualToString:INTEL_TRAINING_URL]) {
		building = [[[SpyTraining alloc] init] autorelease];
    } else if ([request.buildingUrl isEqualToString:MAYHEM_TRAINING_URL]) {
		building = [[[SpyTraining alloc] init] autorelease];
    } else if ([request.buildingUrl isEqualToString:THEFT_TRAINING_URL]) {
		building = [[[SpyTraining alloc] init] autorelease];
    } else if ([request.buildingUrl isEqualToString:POLITICS_TRAINING_URL]) {
		building = [[[SpyTraining alloc] init] autorelease];

    } else if ([request.buildingUrl isEqualToString:PARLIAMENT_URL]) {
		building = [[[Parliament alloc] init] autorelease];
    } else if ([request.buildingUrl isEqualToString:POLICE_STATION_URL]) {
		building = [[[PoliceStation alloc] init] autorelease];
    } else if ([request.buildingUrl isEqualToString:STATION_COMMAND_URL]) {
		building = [[[StationCommand alloc] init] autorelease];
    } else if ([request.buildingUrl isEqualToString:WAREHOUSE_URL]) {
		building = [[[Module alloc] init] autorelease];
	} else {
		building = [[[Building alloc] init] autorelease];
	}
	
	building.buildingUrl = request.buildingUrl;
	[building parseData:request.result];
	return building;
}


@end
