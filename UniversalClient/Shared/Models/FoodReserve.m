//
//  FoodReserve.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "FoodReserve.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEBuildingDump.h"
#import "LETableViewCellButton.h"
#import "ViewDictionaryController.h"
#import "DumpFoodController.h"


@implementation FoodReserve


@synthesize storedFood;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.storedFood = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
	self.storedFood = [data objectForKey:@"food_stored"];
}


- (void)generateSections {
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_STORED_FOOD], [NSDecimalNumber numberWithInt:BUILDING_ROW_DUMP_RESOURCE]), @"rows");
	
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_STORED_FOOD:
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
		case BUILDING_ROW_STORED_FOOD:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *storedFoodCell = [LETableViewCellButton getCellForTableView:tableView];
			storedFoodCell.textLabel.text = @"View Food By Type";
			cell = storedFoodCell;
			break;
		case BUILDING_ROW_DUMP_RESOURCE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *dumpOreCell = [LETableViewCellButton getCellForTableView:tableView];
			dumpOreCell.textLabel.text = @"Dump Food";
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
		case BUILDING_ROW_STORED_FOOD:
			; //DO NOT REMOVE
			ViewDictionaryController *viewDictionaryController = [ViewDictionaryController createWithName:@"Food By Type" useLongLabels:NO icon:FOOD_ICON];
			viewDictionaryController.data = self.storedFood;
			return viewDictionaryController;
			break;
		case BUILDING_ROW_DUMP_RESOURCE:
			; //DO NOT REMOVE
			DumpFoodController *dumpFoodController = [DumpFoodController create];
			dumpFoodController.foodReserve = self;
			return dumpFoodController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)dumpFood:(NSDecimalNumber *)amount type:(NSString *)type target:(id)inDumpFoodTarget callback:(SEL)inDumpFoodCallback {
	self->dumpFoodTarget = inDumpFoodTarget;
	self->dumpFoodCallback = inDumpFoodCallback;
	[[[LEBuildingDump alloc] initWithCallback:@selector(foodDumped:) target:self buildingId:self.id buildingUrl:self.buildingUrl type:type amount:amount] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)foodDumped:(LEBuildingDump *)request {
	NSDecimalNumber *originalAmount = [Util asNumber:[self.storedFood objectForKey:request.type]];
	NSDecimalNumber *newAmount = [originalAmount decimalNumberBySubtracting:request.amount];
	[self.storedFood setObject:newAmount forKey:request.type];
	[self->dumpFoodTarget performSelector:self->dumpFoodCallback withObject:request];
	return nil;
}


@end
