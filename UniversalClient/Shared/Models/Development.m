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
#import "LETableViewCellBuildQueueItem.h"


@implementation Development


@synthesize costToSubsidize;
@synthesize buildQueue;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.costToSubsidize = nil;
	self.buildQueue = nil;
	[super dealloc];
}

#pragma mark -
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
		[buildQueueItem setObject:[NSDecimalNumber numberWithInt:secondsRemaining] forKey:@"seconds_remaining"];
	}
	
	if (requestReload) {
		self.needsReload = YES;
	} else {
		self.needsRefresh = YES;
	}

	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	self.costToSubsidize = [Util asNumber:[data objectForKey:@"subsidy_cost"]];
	self.buildQueue = [data objectForKey:@"build_queue"];
}


- (void)generateSections {
	NSMutableArray *buildQueueRows = [NSMutableArray arrayWithCapacity:2];
	NSInteger buildQueueSize = [buildQueue count];
	if (buildQueueSize > 0) {
		for (int i=0; i<buildQueueSize; i++) {
			[buildQueueRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_BUILD_QUEUE_ITEM]];
		}
		[buildQueueRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_SUBSIDIZE_BUILD_QUEUE]];
	} else {
		[buildQueueRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_EMPTY]];
	}

	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Build Queue", @"name", buildQueueRows, @"rows"), [self generateHealthSection], [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_SUBSIDIZE_BUILD_QUEUE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_BUILD_QUEUE_ITEM:
			return [LETableViewCellBuildQueueItem getHeightForTableView:tableView];
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
			subsidizeBuildQueueButtonCell.textLabel.text = [NSString stringWithFormat:@"Subsidize (%@ essentia)", self.costToSubsidize];
			cell = subsidizeBuildQueueButtonCell;
			break;
		case BUILDING_ROW_BUILD_QUEUE_ITEM:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			NSDictionary *buildQueueItem = [self.buildQueue objectAtIndex:rowIndex];
			LETableViewCellBuildQueueItem *buildQueueItemCell = [LETableViewCellBuildQueueItem getCellForTableView:tableView];
			[buildQueueItemCell setData:buildQueueItem];
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


#pragma mark -
#pragma mark Callback Methods

- (id)subsidizedBuildQueue:(LEBuildingSubsidizeBuildQueue *)request {
	self.needsReload = YES;
	return nil;
}


@end
