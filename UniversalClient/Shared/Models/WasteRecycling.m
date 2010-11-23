//
//  WasteRecycling.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "WasteRecycling.h"
#import "LEMacros.h"
#import "Util.h"
#import "BuildingUtil.h"
#import "LETableViewCellButton.h"
#import "RecycleController.h"
#import "LEBuildingSubsidizeRecycling.h"
#import "LETableViewCellLabeledText.h";


@implementation WasteRecycling


@synthesize canRecycle;
@synthesize secondsPerResource;
@synthesize maxResources;
@synthesize secondsRemaining;


#pragma mark -
#pragma mark NSObject Methods

- (void)dealloc {
	self.secondsPerResource = nil;
	self.maxResources = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods

- (BOOL)tick:(NSInteger)interval {
	if (self.secondsRemaining > 0) {
		self.secondsRemaining -= interval;
		if (self.secondsRemaining <= 0) {
			self.secondsRemaining = 0;
			self.canRecycle = YES;
			[self generateSections];
		}
		self.needsRefresh = YES;
	}
	return [super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	NSDictionary *recycleData = [data objectForKey:@"recycle"];
	NSLog(@"Recycle Data: %@", recycleData);
	self.canRecycle = [[recycleData objectForKey:@"can"] boolValue];
	self.secondsPerResource = [Util asNumber:[recycleData objectForKey:@"seconds_per_resource"]];
	self.maxResources = [Util asNumber:[recycleData objectForKey:@"max_recycle"]];
	self.secondsRemaining = _intv([recycleData objectForKey:@"seconds_remaining"]);
}


- (void)generateSections {
	NSMutableDictionary *productionSection = [self generateProductionSection];
	[[productionSection objectForKey:@"rows"] addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_MAX_RECYCLE]];

	NSMutableArray *actionRows = [NSMutableArray arrayWithCapacity:2];
	if (self.canRecycle) {
		[actionRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_RECYCLE]];
	} else {
		[actionRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_RECYCLE_PENDING]];
		[actionRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_SUBSIDIZE]];
	}
	self.sections = _array(productionSection, _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", actionRows, @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_MAX_RECYCLE:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_RECYCLE:
		case BUILDING_ROW_SUBSIDIZE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_RECYCLE_PENDING:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_MAX_RECYCLE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *maxRecycleCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			maxRecycleCell.label.text = @"Max Recycle";
			maxRecycleCell.content.text = [Util prettyNSDecimalNumber:self.maxResources];
			cell = maxRecycleCell;
			break;
		case BUILDING_ROW_RECYCLE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *recycleButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			recycleButtonCell.textLabel.text = @"Recycle";
			cell = recycleButtonCell;
			break;
		case BUILDING_ROW_RECYCLE_PENDING:
			 ; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			 LETableViewCellLabeledText *recyclingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			 recyclingCell.label.text = @"Recycling";
			 recyclingCell.content.text = [Util prettyDuration:self.secondsRemaining];
			 cell = recyclingCell;
			 break;
		case BUILDING_ROW_SUBSIDIZE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *subsidizeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			subsidizeButtonCell.textLabel.text = @"Subsidize";
			cell = subsidizeButtonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_RECYCLE:
			; //DO NOT REMOVE
			RecycleController *recycleController = [RecycleController create];
			recycleController.wasteRecycling = self;
			recycleController.secondsPerResource = self.secondsPerResource;
			return recycleController;
			break;
		case BUILDING_ROW_SUBSIDIZE:
			[[[LEBuildingSubsidizeRecycling alloc] initWithCallback:@selector(subsidizedRecycling:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
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
		case BUILDING_ROW_SUBSIDIZE:
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
		case BUILDING_ROW_SUBSIDIZE:
			return @"This will cost you 2 essentia. Do you wish to continue?";
			break;
		default:
			return [super confirmMessage:indexPath];
			break;
	}
}


#pragma mark -
#pragma mark Callback Methods

- (id)subsidizedRecycling:(LEBuildingSubsidizeRecycling *)request {
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
	self.needsRefresh = YES;
	return nil;
}


@end
