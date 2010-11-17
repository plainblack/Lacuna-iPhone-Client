//
//  Capitol.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Capitol.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEBuildingRenameEmpire.h"
#import "LETableViewCellButton.h"
#import "RenameEmpireController.h"


@implementation Capitol


@synthesize renameEmpireCost;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.renameEmpireCost = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"renameEmpireCost:%@", self.renameEmpireCost];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
	self.renameEmpireCost = [Util asNumber:[data objectForKey:@"rename_empire_cost"]];
}


- (void)generateSections {
	
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_RENAME_EMPIRE]), @"rows");
	
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_RENAME_EMPIRE:
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
		case BUILDING_ROW_RENAME_EMPIRE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *renameEmpireCell = [LETableViewCellButton getCellForTableView:tableView];
			renameEmpireCell.textLabel.text = @"Rename Empire";
			cell = renameEmpireCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_RENAME_EMPIRE:
			; //DO NOT REMOVE
			RenameEmpireController *renameEmpireController = [RenameEmpireController create];
			renameEmpireController.capitol = self;
			return renameEmpireController;
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)renameEmpire:(NSString *)newEmpireName target:(id)inRenameEmpireTarget callback:(SEL)inRenameEmpireCallback {
	self->renameEmpireTarget = inRenameEmpireTarget;
	self->renameEmpireCallback = inRenameEmpireCallback;
	[[[LEBuildingRenameEmpire alloc] initWithCallback:@selector(empireRenamed:) target:self buildingId:self.id buildingUrl:self.buildingUrl newEmpireName:newEmpireName] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)empireRenamed:(LEBuildingRenameEmpire *)request {
	[self->renameEmpireTarget performSelector:self->renameEmpireCallback withObject:request];
	return nil;
}


@end
