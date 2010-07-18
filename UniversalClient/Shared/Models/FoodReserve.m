//
//  FoodReserve.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "FoodReserve.h"
#import "LEMacros.h"
#import "LETableViewCellDictionary.h"


@implementation FoodReserve


@synthesize storedFood;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.storedFood = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data tmpSections:(NSMutableArray *)tmpSections {
	self.storedFood = [data objectForKey:@"food_stored"];
	[tmpSections addObject:_dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSNumber numberWithInt:BUILDING_ROW_STORED_FOOD]), @"rows")];
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_STORED_FOOD:
			return [LETableViewCellDictionary getHeightForTableView:tableView numItems:[self.storedFood count]];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_STORED_FOOD:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellDictionary *storedFoodCell = [LETableViewCellDictionary getCellForTableView:tableView];
			[storedFoodCell setHeading:@"Food" Data:self.storedFood];
			cell = storedFoodCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


@end
