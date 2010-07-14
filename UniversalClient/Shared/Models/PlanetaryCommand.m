//
//  PlanetaryCommand.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PlanetaryCommand.h"
#import "LEMacros.h"
#import "Util.h"
#import "BuildingUtil.h"
#import "LETableViewCellLabeledText.h"


@implementation PlanetaryCommand


@synthesize nextColonyCost;


#pragma mark --
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data tmpSections:(NSMutableArray *)tmpSections {
	self.nextColonyCost = [data objectForKey:@"next_colony_cost"];
	
	for (NSMutableDictionary *section in tmpSections) {
		if (_intv([section objectForKey:@"type"]) == BUILDING_SECTION_BUILDING) {
			[[section objectForKey:@"rows"] addObject:[NSNumber numberWithInt:BUILDING_ROW_NEXT_COLONY_COST]];
		}
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_NEXT_COLONY_COST:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_NEXT_COLONY_COST:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *nextColonyCostCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			nextColonyCostCell.label.text = @"Next Colony";
			nextColonyCostCell.content.text = [Util prettyNSNumber:self.nextColonyCost];
			cell = nextColonyCostCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


@end
