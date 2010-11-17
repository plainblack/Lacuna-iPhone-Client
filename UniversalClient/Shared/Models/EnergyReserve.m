//
//  EnergyReserve.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "EnergyReserve.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEBuildingDump.h"
#import "LETableViewCellButton.h"
#import "DumpEnergyController.h"


@implementation EnergyReserve


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
			LETableViewCellButton *dumpEnergyCell = [LETableViewCellButton getCellForTableView:tableView];
			dumpEnergyCell.textLabel.text = @"Dump Energy";
			cell = dumpEnergyCell;
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
			DumpEnergyController *dumpEnergyController = [DumpEnergyController create];
			dumpEnergyController.energyReserve = self;
			return dumpEnergyController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)dumpEnergy:(NSDecimalNumber *)amount target:(id)inDumpEnergyTarget callback:(SEL)inDumpEnergyCallback {
	self->dumpEnergyTarget = inDumpEnergyTarget;
	self->dumpEnergyCallback = inDumpEnergyCallback;
	[[[LEBuildingDump alloc] initWithCallback:@selector(energyDumped:) target:self buildingId:self.id buildingUrl:self.buildingUrl amount:amount] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)energyDumped:(LEBuildingDump *)request {
	[self->dumpEnergyTarget performSelector:self->dumpEnergyCallback withObject:request];
	return nil;
}


@end
