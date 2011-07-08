//
//  GeneticsLab.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "GeneticsLab.h"
#import "LEMacros.h"
#import "Util.h"
#import "BuildingUtil.h"
#import "LETableViewCellButton.h"
#import "LEBuildingPrepareExperiment.h"
#import "LEBuildingRunExperiment.h"
#import "LEBuildingRenameSpecies.h"
#import "PrepareExperimentController.h"
#import "RenameSpeciesController.h"


@implementation GeneticsLab


#pragma mark -
#pragma mark NSObject Methods

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_EXPERIMENT], [NSDecimalNumber numberWithInt:BUILDING_ROW_EDIT_NAME]), @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_EXPERIMENT:
        case BUILDING_ROW_EDIT_NAME:
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
		case BUILDING_ROW_EXPERIMENT:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewStarButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewStarButtonCell.textLabel.text = @"New Experiment";
			cell = viewStarButtonCell;
			break;
		case BUILDING_ROW_EDIT_NAME:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *renameSpeciesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			renameSpeciesButtonCell.textLabel.text = @"Rename Species";
			cell = renameSpeciesButtonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_EXPERIMENT:
			; //DO NOT REMOVE
			PrepareExperimentController *prepareExperimentController = [PrepareExperimentController create];
			prepareExperimentController.geneticsLab = self;
			return prepareExperimentController;
			break;
		case BUILDING_ROW_EDIT_NAME:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
            RenameSpeciesController *renameSpeciesController = [RenameSpeciesController create];
            renameSpeciesController.geneticsLab = self;
            return renameSpeciesController;
            break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)prepareExperiments:(id)target callback:(SEL)callback {
	self->prepareExperimentTarget = target;
	self->prepareExperimentCallback = callback;
	[[[LEBuildingPrepareExperiment alloc] initWithCallback:@selector(preparedExperiments:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}

- (void)changeName:(NSString *)speciesName description:(NSString *)description forTarger:(id)target callback:(SEL)callback {
    self->changeNameTarget = target;
    self->changeNameCallback = callback;
    [[[LEBuildingRenameSpecies alloc] initWithCallback:@selector(renamedSpecies:) target:self buildingId:self.id buildingUrl:self.buildingUrl speciesName:speciesName speciesDescription:description] autorelease];
}


- (void)runExperimentWithSpy:(NSString *)spyId affinity:(NSString *)affinity target:(id)target callback:(SEL)callback {
	self->runExperimentTarget = target;
	self->runExperimentCallback = callback;
	[[[LEBuildingRunExperiment alloc] initWithCallback:@selector(ranExperiment:) target:self buildingId:self.id buildingUrl:self.buildingUrl spyId:spyId affinity:affinity] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)preparedExperiments:(LEBuildingPrepareExperiment *)request {
	[self->prepareExperimentTarget performSelector:self->prepareExperimentCallback withObject:request];
}


- (void)renamedSpecies:(LEBuildingRenameSpecies *)request {
	[self->changeNameTarget performSelector:self->changeNameCallback withObject:request];
}


- (void)ranExperiment:(LEBuildingRunExperiment *)request {
	[self->runExperimentTarget performSelector:self->runExperimentCallback withObject:request];
}


@end
