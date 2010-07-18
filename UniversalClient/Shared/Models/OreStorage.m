//
//  OreStorage.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "OreStorage.h"
#import "LEMacros.h"
#import "LETableViewCellDictionary.h"


@implementation OreStorage


@synthesize storedOre;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.storedOre = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data tmpSections:(NSMutableArray *)tmpSections {
	self.storedOre = [data objectForKey:@"ore_stored"];
	
	[tmpSections addObject:_dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Storage", @"name", _array([NSNumber numberWithInt:BUILDING_ROW_STORED_ORE]), @"rows")];
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_STORED_ORE:
			return [LETableViewCellDictionary getHeightForTableView:tableView numItems:[self.storedOre count]];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_STORED_ORE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellDictionary *storedOreCell = [LETableViewCellDictionary getCellForTableView:tableView];
			[storedOreCell setHeading:@"Ore" Data:self.storedOre];
			cell = storedOreCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


@end
