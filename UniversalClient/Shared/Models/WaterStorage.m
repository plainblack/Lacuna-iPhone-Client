//
//  WaterStorage.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "WaterStorage.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEBuildingDump.h"
#import "LETableViewCellButton.h"
#import "DumpWaterController.h"


@implementation WaterStorage


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_DUMP_RESOURCE]), @"rows");
	
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_DUMP_RESOURCE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_DUMP_RESOURCE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *dumpWaterCell = [LETableViewCellButton getCellForTableView:tableView];
			dumpWaterCell.textLabel.text = @"Dump Water";
			cell = dumpWaterCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_DUMP_RESOURCE:
			; //DO NOT REMOVE
			DumpWaterController *dumpWaterController = [DumpWaterController create];
			dumpWaterController.waterStorage = self;
			return dumpWaterController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)dumpWater:(NSDecimalNumber *)amount target:(id)inDumpWaterTarget callback:(SEL)inDumpWaterCallback {
	self->dumpWaterTarget = inDumpWaterTarget;
	self->dumpWaterCallback = inDumpWaterCallback;
	[[[LEBuildingDump alloc] initWithCallback:@selector(waterDumped:) target:self buildingId:self.id buildingUrl:self.buildingUrl amount:amount] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)waterDumped:(LEBuildingDump *)request {
	[self->dumpWaterTarget performSelector:self->dumpWaterCallback withObject:request];
	return nil;
}


@end
