//
//  SubspaceSupplyDepot.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SubspaceSupplyDepot.h"
#import "LEMacros.h"
#import "Util.h"
#import "MapBuilding.h"
#import "LETableViewCellButton.h"
#import "LEBuildingCompleteBuildQueue.h"
#import "LEBuildingTransmitEnergy.h"
#import "LEBuildingTransmitFood.h"
#import "LEBuildingTransmitOre.h"
#import "LEBuildingTransmitWater.h"
#import "LEBuildingSubsidizeParty.h"


@implementation SubspaceSupplyDepot


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods


- (void)generateSections {
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Party", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_COMPLETE_BUILD_QUEUE], [NSDecimalNumber numberWithInt:BUILDING_ROW_TRANSMIT_ENERGY], [NSDecimalNumber numberWithInt:BUILDING_ROW_TRANSMIT_FOOD], [NSDecimalNumber numberWithInt:BUILDING_ROW_TRANSMIT_ORE], [NSDecimalNumber numberWithInt:BUILDING_ROW_TRANSMIT_WATER]), @"rows");
	
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_COMPLETE_BUILD_QUEUE:
		case BUILDING_ROW_TRANSMIT_ENERGY:
		case BUILDING_ROW_TRANSMIT_FOOD:
		case BUILDING_ROW_TRANSMIT_ORE:
		case BUILDING_ROW_TRANSMIT_WATER:
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
		case BUILDING_ROW_COMPLETE_BUILD_QUEUE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *completeBuildQueueCell = [LETableViewCellButton getCellForTableView:tableView];
			completeBuildQueueCell.textLabel.text = @"Complete Build Queue";
			cell = completeBuildQueueCell;
			break;
		case BUILDING_ROW_TRANSMIT_ENERGY:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *transmitEnergyCell = [LETableViewCellButton getCellForTableView:tableView];
			transmitEnergyCell.textLabel.text = @"Transmit Energy";
			cell = transmitEnergyCell;
			break;
		case BUILDING_ROW_TRANSMIT_FOOD:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *transmitFoodCell = [LETableViewCellButton getCellForTableView:tableView];
			transmitFoodCell.textLabel.text = @"Transmit Food";
			cell = transmitFoodCell;
			break;
		case BUILDING_ROW_TRANSMIT_ORE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *transmitOreCell = [LETableViewCellButton getCellForTableView:tableView];
			transmitOreCell.textLabel.text = @"Transmit Ore";
			cell = transmitOreCell;
			break;
		case BUILDING_ROW_TRANSMIT_WATER:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *transmitWaterCell = [LETableViewCellButton getCellForTableView:tableView];
			transmitWaterCell.textLabel.text = @"Transmit Water";
			cell = transmitWaterCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_COMPLETE_BUILD_QUEUE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			[[[LEBuildingCompleteBuildQueue alloc] initWithCallback:@selector(buildQueueCompleted:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		case BUILDING_ROW_TRANSMIT_ENERGY:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			[[[LEBuildingTransmitEnergy alloc] initWithCallback:@selector(energyTransmitted:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		case BUILDING_ROW_TRANSMIT_FOOD:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			[[[LEBuildingTransmitFood alloc] initWithCallback:@selector(foodTransmitted:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		case BUILDING_ROW_TRANSMIT_ORE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			[[[LEBuildingTransmitOre alloc] initWithCallback:@selector(oreTransmitted:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		case BUILDING_ROW_TRANSMIT_WATER:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			[[[LEBuildingTransmitWater alloc] initWithCallback:@selector(waterTransmitted:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


- (BOOL)isConfirmCell:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	switch (_intv([rows objectAtIndex:indexPath.row])) {
		case BUILDING_ROW_COMPLETE_BUILD_QUEUE:
			return YES;
			break;
		default:
			return [super isConfirmCell:indexPath];
			break;
	}
}


- (NSString *)confirmMessage:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	switch (_intv([rows objectAtIndex:indexPath.row])) {
		case BUILDING_ROW_COMPLETE_BUILD_QUEUE:
			return @"This will consume seconds to complete build queue time. Are you sure you want to do this?";
			break;
		default:
			return [super confirmMessage:indexPath];
			break;
	}
}


#pragma mark -
#pragma mark Callback Methods

- (void)buildQueueCompleted:(LEBuildingCompleteBuildQueue*)request {
	NSMutableDictionary *workData = [request.buildingData objectForKey:@"work"];
	[self parseWorkData:workData];
	[[self findMapBuilding] updateWork:workData];
	self.needsRefresh = YES;
}


- (void)energyTransmitted:(LEBuildingTransmitEnergy *)request {
	NSMutableDictionary *workData = [request.buildingData objectForKey:@"work"];
	[self parseWorkData:workData];
	[[self findMapBuilding] updateWork:workData];
	self.needsRefresh = YES;
}


- (void)foodTransmitted:(LEBuildingTransmitFood *)request {
	NSMutableDictionary *workData = [request.buildingData objectForKey:@"work"];
	[self parseWorkData:workData];
	[[self findMapBuilding] updateWork:workData];
	self.needsRefresh = YES;
}


- (void)oreTransmitted:(LEBuildingTransmitOre *)request {
	NSMutableDictionary *workData = [request.buildingData objectForKey:@"work"];
	[self parseWorkData:workData];
	[[self findMapBuilding] updateWork:workData];
	self.needsRefresh = YES;
}


- (void)waterTransmitted:(LEBuildingTransmitWater *)request {
	NSMutableDictionary *workData = [request.buildingData objectForKey:@"work"];
	[self parseWorkData:workData];
	[[self findMapBuilding] updateWork:workData];
	self.needsRefresh = YES;
}


@end
