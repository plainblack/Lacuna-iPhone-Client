//
//  HallsOfVrbansk.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "HallsOfVrbansk.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LEBuildingGetUpgradableBuildings.h"
#import "LEBuildingSacrificeToUpgrade.h"
#import "ViewUpgradableBuildingsController.h"


@implementation HallsOfVrbansk


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Party", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_UPGRADABLE_BUILDINGS]), @"rows");
	
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_UPGRADABLE_BUILDINGS:
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
		case BUILDING_ROW_VIEW_UPGRADABLE_BUILDINGS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *researchSpeciesCell = [LETableViewCellButton getCellForTableView:tableView];
			researchSpeciesCell.textLabel.text = @"View upgradable buildings";
			cell = researchSpeciesCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_UPGRADABLE_BUILDINGS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			ViewUpgradableBuildingsController *viewUpgradableBuildingsController = [ViewUpgradableBuildingsController create];
			viewUpgradableBuildingsController.hallsOfVrbansk = self;
			return viewUpgradableBuildingsController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)getUpgradableBuildingsTarget:(id)target callback:(SEL)callback {
	self->getUpgradableBuildingsTarget = target;
	self->getUpgradableBuildingsCallback = callback;
	[[[LEBuildingGetUpgradableBuildings alloc] initWithCallback:@selector(loadedUpgradableBuildings:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)upgradeBuilding:(NSString *)upgradeBuildingId target:(id)target callback:(SEL)callback {
	self->upgradeBuildingTarget = target;
	self->upgradeBuildingCallback = callback;
	[[[LEBuildingSacrificeToUpgrade alloc] initWithCallback:@selector(sacrificed:) target:self buildingId:self.id buildingUrl:self.buildingUrl upgradeBuildingId:upgradeBuildingId] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)loadedUpgradableBuildings:(LEBuildingGetUpgradableBuildings *)request {
	[self->getUpgradableBuildingsTarget performSelector:self->getUpgradableBuildingsCallback withObject:request];
}


- (void)sacrificed:(LEBuildingSacrificeToUpgrade *)request {
	[self->upgradeBuildingTarget performSelector:self->upgradeBuildingCallback withObject:request];
}


@end
