//
//  LibraryOfJith.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "LibraryOfJith.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LEBuildingResearchSpecies.h"
#import "ViewResearchSpeciesStatsController.h"


@implementation LibraryOfJith


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Party", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_RESEARCH_SEPECIES]), @"rows");
	
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_RESEARCH_SEPECIES:
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
		case BUILDING_ROW_RESEARCH_SEPECIES:
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
		case BUILDING_ROW_RESEARCH_SEPECIES:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			ViewResearchSpeciesStatsController *viewResearchSpeciesStatsController = [ViewResearchSpeciesStatsController create];
			viewResearchSpeciesStatsController.libraryOfJith = self;
			return viewResearchSpeciesStatsController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)researchSpecies:(NSString *)empireId target:(id)target callback:(SEL)callback {
	self->researchSpeciesTarget = target;
	self->researchSpeciesCallback = callback;
	[[[LEBuildingResearchSpecies alloc] initWithCallback:@selector(speciesResearched:) target:self buildingId:self.id buildingUrl:self.buildingUrl empireId:empireId] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)speciesResearched:(LEBuildingResearchSpecies*)request {
	[self->researchSpeciesTarget performSelector:self->researchSpeciesCallback withObject:request];
}


@end
