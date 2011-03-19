//
//  DistributionCenter.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/15/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "DistributionCenter.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingGetTradeableStoredResources.h"
#import "LEBuildingReserve.h"
#import "LEBuildingReleaseReserve.h"
#import "ReserveResourcesController.h"
#import "ViewReservesController.h"


@implementation DistributionCenter


@synthesize getStoredResourcesTaget;
@synthesize getStoredResourcesCallback;
@synthesize reserverTaget;
@synthesize reserverCallback;
@synthesize releaseReserverTaget;
@synthesize releaseReserverCallback;
@synthesize secondsRemaining;
@synthesize can;
@synthesize maxReserverDuration;
@synthesize maxReserverSize;
@synthesize resources;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
    self.getStoredResourcesTaget = nil;
    self.getStoredResourcesCallback = nil;
    self.reserverTaget = nil;
    self.reserverCallback = nil;
    self.releaseReserverTaget = nil;
    self.releaseReserverCallback = nil;
    self.maxReserverDuration = nil;
    self.maxReserverSize = nil;
    self.resources = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (BOOL)tick:(NSInteger)interval {
	if (self.secondsRemaining > 0) {
		self.secondsRemaining -= interval;
		if (self.secondsRemaining <= 0) {
			self.secondsRemaining = 0;
			self.can = YES;
            self.resources = nil;
			[self generateSections];
		}
		self.needsRefresh = YES;
	}
	return [super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
    NSMutableDictionary *reserveData = [data objectForKey:@"reserve"];
    id tmp = [reserveData objectForKey:@"seconds_remaining"];
    if (isNotNull(tmp)) {
        self.secondsRemaining = _intv([reserveData objectForKey:@"seconds_remaining"]);
    } else {
        self.secondsRemaining = 0;
    }
	self.can = [[reserveData objectForKey:@"can"] boolValue];
	self.maxReserverDuration = [Util asNumber:[reserveData objectForKey:@"max_reserve_duration"]];
	self.maxReserverSize = [Util asNumber:[reserveData objectForKey:@"max_reserve_size"]];
    self.resources = [reserveData objectForKey:@"resources"];
}


- (void)generateSections {
    NSMutableArray *rows;

    if (self.can) {
        rows = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_MAX_DURATION], [NSDecimalNumber numberWithInt:BUILDING_ROW_MAX_SIZE], [NSDecimalNumber numberWithInt:BUILDING_ROW_STORE_RESOURCES]);
    } else {
        rows = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_STORAGE_DURATION], [NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_RESOURCES]);
    }
	
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Reserves", @"name", rows, @"rows");

	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_MAX_DURATION:
		case BUILDING_ROW_MAX_SIZE:
        case BUILDING_ROW_STORAGE_DURATION:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_STORE_RESOURCES:
		case BUILDING_ROW_VIEW_RESOURCES:
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
		case BUILDING_ROW_MAX_DURATION:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *maxDurationCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			maxDurationCell.label.text = @"Max Duration";
			maxDurationCell.content.text = [Util prettyDuration:_intv(self.maxReserverDuration)];
			cell = maxDurationCell;
			break;
		case BUILDING_ROW_MAX_SIZE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *maxSizeCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			maxSizeCell.label.text = @"Max Storage";
			maxSizeCell.content.text = [Util prettyNSDecimalNumber:self.maxReserverSize];
			cell = maxSizeCell;
			break;
		case BUILDING_ROW_STORAGE_DURATION:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *storageDurationCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			storageDurationCell.label.text = @"Reserved For";
			storageDurationCell.content.text = [Util prettyDuration:self.secondsRemaining];
			cell = storageDurationCell;
			break;
		case BUILDING_ROW_STORE_RESOURCES:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *storeResourcesButton = [LETableViewCellButton getCellForTableView:tableView];
			storeResourcesButton.textLabel.text = @"Reserve Resources";
			cell = storeResourcesButton;
			break;
		case BUILDING_ROW_VIEW_RESOURCES:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewResourcesCell = [LETableViewCellButton getCellForTableView:tableView];
			viewResourcesCell.textLabel.text = @"View Reserves";
			cell = viewResourcesCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_STORE_RESOURCES:
			; //DO NOT REMOVE
			ReserveResourcesController *reserveResourcesController = [ReserveResourcesController create];
			reserveResourcesController.distributionCenter = self;
			return reserveResourcesController;
			break;
		case BUILDING_ROW_VIEW_RESOURCES:
			; //DO NOT REMOVE
			ViewReservesController *viewReservesController = [ViewReservesController create];
			viewReservesController.distributionCenter = self;
			return viewReservesController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)getStoredResourcesTarget:(id)inGetStoredResourcesTaget callback:(SEL)inGetStoredResourcesCallback {
    self.getStoredResourcesTaget = inGetStoredResourcesTaget;
    self.getStoredResourcesCallback = inGetStoredResourcesCallback;
    [[[LEBuildingGetTradeableStoredResources alloc] initWithCallback:@selector(gotStoredResources:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}

- (void)reserve:(NSMutableArray *)reserveResources target:(id)inReserverTaget callback:(SEL)inReserverCallback {
    self.reserverTaget = inReserverTaget;
    self.reserverCallback = inReserverCallback;
    [[[LEBuildingReserve alloc] initWithCallback:@selector(reserved:) target:self buildingId:self.id buildingUrl:self.buildingUrl resources:reserveResources] autorelease];
}

- (void)releaseReserveTarget:(id)inReleaseReserverTaget callback:(SEL)inReleaseReserverCallback {
    self.releaseReserverTaget = inReleaseReserverTaget;
    self.releaseReserverCallback = inReleaseReserverCallback;
    [[[LEBuildingReleaseReserve alloc] initWithCallback:@selector(releasedReserve:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)gotStoredResources:(LEBuildingGetTradeableStoredResources *)request {
    [self.getStoredResourcesTaget performSelector:self.getStoredResourcesCallback withObject:request];
    self.getStoredResourcesTaget = nil;
    self.getStoredResourcesCallback = nil;
}

- (void)reserved:(LEBuildingReserve *)request {
    [self.reserverTaget performSelector:self.reserverCallback withObject:request];
    self.reserverTaget = nil;
    self.reserverCallback = nil;
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
	self.needsRefresh = YES;
}

- (void)releasedReserve:(LEBuildingReleaseReserve *)request {
    [self.releaseReserverTaget performSelector:self.releaseReserverCallback withObject:request];
    self.releaseReserverTaget = nil;
    self.releaseReserverCallback = nil;
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
	self.needsRefresh = YES;
}

@end
