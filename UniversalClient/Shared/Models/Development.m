//
//  Development.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Development.h"
#import	"LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingSubsidizeBuildQueue.h"


@implementation Development


@synthesize costToSubsidize;
@synthesize buildQueue;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.buildQueue = nil;
	[super dealloc];
}

#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	bool requestReload = NO;
	for (NSMutableDictionary *buildQueueItem in self.buildQueue) {
		NSInteger secondsRemaining = _intv([buildQueueItem objectForKey:@"seconds_remaining"]);
		secondsRemaining -= interval;
		if (secondsRemaining <= 0) {
			secondsRemaining = 0;
			requestReload = YES;
		}
		[buildQueueItem setObject:[NSNumber numberWithInt:secondsRemaining] forKey:@"seconds_remaining"];
	}
	
	if (requestReload) {
		self.needsReload = YES;
	} else {
		self.needsRefresh = YES;
	}

	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data tmpSections:(NSMutableArray *)tmpSections {
	self.costToSubsidize = _intv([data objectForKey:@"subsidy_cost"]); 
	self.buildQueue = [data objectForKey:@"build_queue"];
	
	NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
	NSInteger buildQueueSize = [buildQueue count];
	if (buildQueueSize > 0) {
		for (int i=0; i<buildQueueSize; i++) {
			[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_BUILD_QUEUE_ITEM]];
		}
		[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_SUBSIDIZE_BUILD_QUEUE]];
	} else {
		[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_EMPTY]];
	}
	[tmpSections addObject:_dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Build Queue", @"name", rows, @"rows")];
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_SUBSIDIZE_BUILD_QUEUE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_BUILD_QUEUE_ITEM:
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
		case BUILDING_ROW_SUBSIDIZE_BUILD_QUEUE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *subsidizeBuildQueueButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			subsidizeBuildQueueButtonCell.textLabel.text = [NSString stringWithFormat:@"Subsidize (%i essentia)", self.costToSubsidize];
			cell = subsidizeBuildQueueButtonCell;
			break;
		case BUILDING_ROW_BUILD_QUEUE_ITEM:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			NSDictionary *buildQueueItem = [self.buildQueue objectAtIndex:rowIndex];
			LETableViewCellLabeledText *buildQueueItemCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			buildQueueItemCell.label.text = [NSString stringWithFormat:@"Level %@", [buildQueueItem objectForKey:@"to_level"]];
			buildQueueItemCell.content.text = [NSString stringWithFormat:@"%@: %@", [buildQueueItem objectForKey:@"name"], [Util prettyDuration:_intv([buildQueueItem objectForKey:@"seconds_remaining"])]];
			cell = buildQueueItemCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_SUBSIDIZE_BUILD_QUEUE:
			[[[LEBuildingSubsidizeBuildQueue alloc] initWithCallback:@selector(subsidizedBuildQueue:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Callback Methods

- (id)subsidizedBuildQueue:(LEBuildingSubsidizeBuildQueue *)request {
	self.needsReload = YES;
	return nil;
}


@end
