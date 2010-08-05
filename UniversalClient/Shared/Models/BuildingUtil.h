//
//  BuildingUtil.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARCHAEOLOGY_URL @"/archaeology"
#define DEVELOPMENT_URL @"/development"
#define FOOD_RESERVE_URL @"/foodreserve"
#define INTELLIGENCE_URL @"/intelligence"
#define MINING_MINISTRY_URL @"/miningministry"
#define NETWORK_19_URL @"/network19"
#define OBSERVATORY_URL @"/observatory"
#define ORE_STORAGE_URL @"/orestorage"
#define PARK_URL @"/park"
#define PLANETARY_COMMAND_URL @"/planetarycommand"
#define SECURITY_URL @"/security"
#define SHIPYARD_URL @"/shipyard"
#define SPACE_PORT_URL @"/spaceport"
#define WASTE_RECYCLING_URL @"/wasterecycling"

typedef enum {
	BUILDING_SECTION_BUILDING,
	BUILDING_SECTION_HEALTH,
	BUILDING_SECTION_ACTIONS,
	BUILDING_SECTION_UPGRADE
} BUILDING_SECTION;


typedef enum {
	BUILDING_ROW_BUILDING_STATS,
	BUILDING_ROW_UPGRADE_BUILDING_STATS,
	BUILDING_ROW_UPGRADE_BUILDING_COST,
	BUILDING_ROW_UPGRADE_BUTTON,
	BUILDING_ROW_UPGRADE_CANNOT,
	BUILDING_ROW_UPGRADE_PROGRESS,
	BUILDING_ROW_VIEW_NETWORK_19,
	BUILDING_ROW_RESTRICTED_NETWORK_19,
	BUILDING_ROW_UNRESTRICTED_NETWORK_19,
	BUILDING_ROW_NUM_SPIES,
	BUILDING_ROW_SPY_BUILD_COST,
	BUILDING_ROW_BUILD_SPY_BUTTON,
	BUILDING_ROW_VIEW_SPIES_BUTTON,
	BUILDING_ROW_RECYCLE,
	BUILDING_ROW_RECYCLE_PENDING,
	BUILDING_ROW_SUBSIDIZE,
	BUILDING_ROW_THROW_PARTY,
	BUILDING_ROW_PARTY_PENDING,
	BUILDING_ROW_DEMOLISH_BUTTON,
	BUILDING_ROW_BUILD_QUEUE_ITEM,
	BUILDING_ROW_SUBSIDIZE_BUILD_QUEUE,
	BUILDING_ROW_EMPTY,
	BUILDING_ROW_STORAGE,
	BUILDING_ROW_UPGRADE_STORAGE,
	BUILDING_ROW_NEXT_COLONY_COST,
	BUILDING_ROW_VIEW_PRISONERS,
	BUILDING_ROW_MAX_RECYCLE,
	BUILDING_ROW_STORED_FOOD,
	BUILDING_ROW_STORED_ORE,
	BUILDING_ROW_GLYPH_SEARCH,
	BUILDING_ROW_GLYPH_ASSEMBLE,
	BUILDING_ROW_GLYPH_SEARCHING,
	BUILDING_ROW_DOCKED_SHIPS,
	BUILDING_ROW_VIEW_SHIPS,
	BUILDING_ROW_VIEW_TRAVELLING_SHIPS,
	BUILDING_ROW_VIEW_SHIP_BUILD_QUEUE,
	BUILDING_ROW_BUILD_SHIP,
	BUILDING_ROW_VIEW_PROBED_STARS,
	BUILDING_ROW_VIEW_PLATFORMS,
	BUILDING_ROW_VIEW_FLEET_SHIPS,
	BUILDING_ROW_EFFICENCY,
	BUILDING_ROW_REPAIR_COST,
	BUILDING_ROW_REPAIR_BUTTON
} BUILDING_ROW;


@class Building;
@class LEBuildingView;


@interface BuildingUtil : NSObject {

}


+ (Building *)createBuilding:(LEBuildingView *)request;


@end
