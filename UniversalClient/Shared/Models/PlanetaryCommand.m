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


#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
	self.nextColonyCost = [Util asNumber:[data objectForKey:@"next_colony_cost"]];
}


- (void)generateSections {
	NSMutableDictionary *productionSection = [self generateProductionSection];
	[[productionSection objectForKey:@"rows"] addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_NEXT_COLONY_COST]];
	
	self.sections = _array(productionSection, [self generateHealthSection], [self generateUpgradeSection]);
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
			LETableViewCellLabeledText *nextColonyCostCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			nextColonyCostCell.label.text = @"Next Colony";
			nextColonyCostCell.content.text = [Util prettyNSDecimalNumber:self.nextColonyCost];
			cell = nextColonyCostCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


@end
