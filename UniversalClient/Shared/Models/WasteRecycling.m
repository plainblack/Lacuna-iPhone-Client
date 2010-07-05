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


#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	if (self.secondsRemaining > 0) {
		self.secondsRemaining -= interval;
		if (self.secondsRemaining <= 0) {
			self.secondsRemaining = 0;
			self.canRecycle = YES;
			for (NSMutableDictionary *section in self.sections) {
				if ([[section objectForKey:@"name"] isEqualToString:@"Actions"]) {
					[section setObject:_array([NSNumber numberWithInt:BUILDING_ROW_RECYCLE]) forKey:@"rows"];
				}
			}
		}
		self.needsRefresh = YES;
	}
	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data tmpSections:(NSMutableArray *)tmpSections {
	NSDictionary *recycleData = [data objectForKey:@"recycle"];
	self.canRecycle = [[recycleData objectForKey:@"can"] boolValue];
	self.secondsPerResource = _intv([recycleData objectForKey:@"seconds_per_resource"]);
	self.maxResources = _intv([recycleData objectForKey:@"max_recycle"]);
	self.secondsRemaining = _intv([recycleData objectForKey:@"seconds_remaining"]);
	
	NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
	
	if (self.canRecycle) {
		[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_RECYCLE]];
	} else {
		[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_RECYCLE_PENDING]];
		[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_SUBSIDIZE]];
	}
	
	[tmpSections addObject:_dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", rows, @"rows")];
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_RECYCLE:
		case BUILDING_ROW_SUBSIDIZE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_RECYCLE_PENDING:
			return tableView.rowHeight;
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_RECYCLE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *recycleButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			recycleButtonCell.textLabel.text = @"Recycle";
			cell = recycleButtonCell;
			break;
		case BUILDING_ROW_RECYCLE_PENDING:
			 ; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			 LETableViewCellLabeledText *recyclingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
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
			recycleController.buildingId = self.id;
			recycleController.urlPart = self.buildingUrl;
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


#pragma mark --
#pragma mark Callback Methods

- (id)subsidizedRecycling:(LEBuildingSubsidizeRecycling *)request {
	self.needsReload = YES;
	return nil;
}



@end
