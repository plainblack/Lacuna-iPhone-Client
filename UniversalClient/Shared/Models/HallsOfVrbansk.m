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
#import "LEBuildingGetUpgradeableBuildings.h"
#import "LEBuildingSacrificeToUpgrade.h"


@implementation HallsOfVrbansk


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Party", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_UPGRADEABLE_BUILDINGS]), @"rows");
	
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_UPGRADEABLE_BUILDINGS:
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
		case BUILDING_ROW_VIEW_UPGRADEABLE_BUILDINGS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *researchSpeciesCell = [LETableViewCellButton getCellForTableView:tableView];
			researchSpeciesCell.textLabel.text = @"Research Species";
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
		case BUILDING_ROW_VIEW_UPGRADEABLE_BUILDINGS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
//			ViewResearchSpeciesStatsController *viewResearchSpeciesStatsController = [ViewResearchSpeciesStatsController create];
//			viewResearchSpeciesStatsController.libraryOfJith = self;
//			return viewResearchSpeciesStatsController;
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)getUpgradeableBuildingsTarget:(id)target callback:(SEL)callback {
	self->getUpgradeableBuildingsTarget = target;
	self->getUpgradeableBuildingsCallback = callback;
	[[[LEBuildingGetUpgradeableBuildings alloc] initWithCallback:@selector(loadedUpgradeableBuildings:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)upgradeBuilding:(NSString *)upgradeBuildingId target:(id)target callback:(SEL)callback {
	self->upgradeBuildingTarget = target;
	self->upgradeBuildingCallback = callback;
	[[[LEBuildingSacrificeToUpgrade alloc] initWithCallback:@selector(sacrificed:) target:self buildingId:self.id buildingUrl:self.buildingUrl upgradeBuildingId:upgradeBuildingId] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)loadedUpgradeableBuildings:(LEBuildingGetUpgradeableBuildings *)request {
	[self->getUpgradeableBuildingsTarget performSelector:self->getUpgradeableBuildingsCallback withObject:request];
}


- (void)sacrificed:(LEBuildingSacrificeToUpgrade *)request {
	[self->upgradeBuildingTarget performSelector:self->upgradeBuildingCallback withObject:request];
}


@end
