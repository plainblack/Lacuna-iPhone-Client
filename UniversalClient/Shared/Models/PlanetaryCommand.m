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
#import "Session.h"
#import "BuildingUtil.h"
#import "LETableViewCellLabeledIconText.h"


@implementation PlanetaryCommand


@synthesize nextColonyCost;


#pragma mark -
#pragma mark NSObject Methods

- (void)dealloc {
	self.nextColonyCost = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
	self.nextColonyCost = [Util asNumber:[data objectForKey:@"next_colony_cost"]];
}


- (void)generateSections {
	NSMutableDictionary *nextColonySection = _dict(
												   [NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type",
												   @"Next Colony", @"name",
												   _array([NSDecimalNumber numberWithInt:BUILDING_ROW_NEXT_COLONY_COST], [NSDecimalNumber numberWithInt:BUILDING_ROW_CURRENT_HAPPINESS]), @"rows");
	
	self.sections = _array([self generateProductionSection], nextColonySection, [self generateHealthSection], [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_NEXT_COLONY_COST:
		case BUILDING_ROW_CURRENT_HAPPINESS:
			return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
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
			LETableViewCellLabeledIconText *nextColonyCostCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
			nextColonyCostCell.label.text = @"Cost";
			nextColonyCostCell.icon.image = HAPPINESS_ICON;
			nextColonyCostCell.content.text = [Util prettyNSDecimalNumber:self.nextColonyCost];
			cell = nextColonyCostCell;
			break;
		case BUILDING_ROW_CURRENT_HAPPINESS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledIconText *currentHappinessCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
			currentHappinessCell.label.text = @"Current";
			currentHappinessCell.icon.image = HAPPINESS_ICON;
			Session *session = [Session sharedInstance];
			currentHappinessCell.content.text = [Util prettyNSDecimalNumber:session.body.happiness.current];
			cell = currentHappinessCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


@end
