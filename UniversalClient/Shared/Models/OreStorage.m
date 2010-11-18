//
//  OreStorage.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "OreStorage.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEBuildingDump.h"
#import "LETableViewCellButton.h"
#import "ViewDictionaryController.h"
#import "DumpOreController.h"


@implementation OreStorage


@synthesize storedOre;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.storedOre = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
	self.storedOre = [data objectForKey:@"ore_stored"];
}


- (void)generateSections {
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_STORED_ORE], [NSDecimalNumber numberWithInt:BUILDING_ROW_DUMP_RESOURCE]), @"rows");
	
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_STORED_ORE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
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
		case BUILDING_ROW_STORED_ORE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *storedOreCell = [LETableViewCellButton getCellForTableView:tableView];
			storedOreCell.textLabel.text = @"View Ore By Type";
			cell = storedOreCell;
			break;
		case BUILDING_ROW_DUMP_RESOURCE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *dumpOreCell = [LETableViewCellButton getCellForTableView:tableView];
			dumpOreCell.textLabel.text = @"Dump Ore";
			cell = dumpOreCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_STORED_ORE:
			; //DO NOT REMOVE
			ViewDictionaryController *viewDictionaryController = [ViewDictionaryController createWithName:@"Ore By Type" useLongLabels:NO icon:ORE_ICON];
			viewDictionaryController.data = self.storedOre;
			return viewDictionaryController;
			break;
		case BUILDING_ROW_DUMP_RESOURCE:
			; //DO NOT REMOVE
			DumpOreController *dumpOreController = [DumpOreController create];
			dumpOreController.oreStorage = self;
			return dumpOreController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)dumpOre:(NSDecimalNumber *)amount type:(NSString *)type target:(id)inDumpOreTarget callback:(SEL)inDumpOreCallback {
	self->dumpOreTarget = inDumpOreTarget;
	self->dumpOreCallback = inDumpOreCallback;
	[[[LEBuildingDump alloc] initWithCallback:@selector(oreDumped:) target:self buildingId:self.id buildingUrl:self.buildingUrl type:type amount:amount] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)oreDumped:(LEBuildingDump *)request {
	NSDecimalNumber *originalAmount = [Util asNumber:[[self.storedOre objectForKey:request.type] stringValue]];
	NSDecimalNumber *newAmount = [originalAmount decimalNumberBySubtracting:request.amount];
	[self.storedOre setObject:newAmount forKey:request.type];
	[self->dumpOreTarget performSelector:self->dumpOreCallback withObject:request];
	return nil;
}


@end
