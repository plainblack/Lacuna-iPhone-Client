//
//  Building.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Building.h"
#import "BuildingUtil.h"
#import "LEMacros.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellBuildingStats.h"
#import "LETableViewCellCost.h"
#import "LETableViewCellUnbuildable.h"
#import "LETableViewCellProgress.h"
#import "LETableViewCellBuildingStorage.h"
#import "LEUpgradeBuilding.h"
#import "LEBuildingDemolish.h"
#import "LEBuildingRestrictCoverage.h"
#import "LEBuildingTrainSpy.h"
#import "LEBuildingSubsidizeBuildQueue.h"
#import "LEBuildingThrowParty.h"
#import "ViewSpiesController.h"

@implementation Building


@synthesize id;
@synthesize buildingUrl;
@synthesize name;
@synthesize imageName;
@synthesize level;
@synthesize x;
@synthesize y;
@synthesize resourcesPerHour;
@synthesize resourceCapacity;
@synthesize pendingBuild;
@synthesize work;
@synthesize canUpgrade;
@synthesize cannotUpgradeReason;
@synthesize upgradeCost;
@synthesize upgradedResourcePerHour;
@synthesize upgradedResourceStorage;
@synthesize upgradedImageName;
@synthesize sections;
@synthesize demolished;
@synthesize needsReload;
@synthesize needsRefresh;


#pragma mark --
#pragma mark NSObject Methods

- (void)dealloc {
	self.id = nil;
	self.buildingUrl = nil;
	self.name = nil;
	self.imageName = nil;
	self.resourcesPerHour = nil;
	self.resourceCapacity = nil;
	self.pendingBuild = nil;
	self.work = nil;
	self.cannotUpgradeReason = nil;
	self.upgradeCost = nil;
	self.upgradedResourcePerHour = nil;
	self.upgradedResourceStorage = nil;
	self.upgradedImageName = nil;
	self.sections = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	NSDictionary *buildingData = [data objectForKey:@"building"];

	self.id = [buildingData objectForKey:@"id"];
	self.name = [buildingData objectForKey:@"name"];
	self.imageName = [buildingData objectForKey:@"image"];
	self.level = _intv([buildingData objectForKey:@"level"]);
	self.x = _intv([buildingData objectForKey:@"x"]);
	self.y = _intv([buildingData objectForKey:@"y"]);

	if (!self.resourcesPerHour) {
		self.resourcesPerHour = [[[ResourceGeneration alloc] init] autorelease];
	}
	[self.resourcesPerHour parseData:buildingData];

	if (!self.resourceCapacity) {
		self.resourceCapacity = [[[ResourceStorage alloc] init] autorelease];
	}
	[self.resourceCapacity parseData:buildingData];

	NSDictionary *pendingBuildDict = [buildingData objectForKey:@"pending_build"]; 
	if ( pendingBuildDict && ((id)pendingBuildDict != [NSNull null]) ) {
		if(!self.pendingBuild) {
			self.pendingBuild = [[[TimedActivity alloc] init] autorelease];
		}
		[self.pendingBuild parseData:pendingBuildDict];
	} else {
		self.pendingBuild = nil;
	}

	if(!self.work) {
		self.work = [[[TimedActivity alloc] init] autorelease];
	}
	[self.work parseData:[buildingData objectForKey:@"work"]];

	NSDictionary *upgradeData = [buildingData objectForKey:@"upgrade"];
	if (upgradeData) {
		self.canUpgrade = _intv([upgradeData objectForKey:@"can"]) == 1;
		self.cannotUpgradeReason = [upgradeData objectForKey:@"reason"];
		
		if (!self.upgradeCost) {
			self.upgradeCost = [[[ResourceCost alloc] init] autorelease];
		}
		[self.upgradeCost parseData:[upgradeData objectForKey:@"cost"]];
		
		if (!self.upgradedResourcePerHour) {
			self.upgradedResourcePerHour = [[[ResourceGeneration alloc] init] autorelease];
		}
		[self.upgradedResourcePerHour parseData:[upgradeData objectForKey:@"production"]];
		
		if (!self.upgradedResourceStorage) {
			self.upgradedResourceStorage = [[[ResourceStorage alloc] init] autorelease];
		}
		[self.upgradedResourceStorage parseData:[upgradeData objectForKey:@"production"]];
		
		self.upgradedImageName = [buildingData objectForKey:@"image"];
	}
	
	
	NSMutableArray *tmpSections = [NSMutableArray arrayWithCapacity:5];
	if (self.resourceCapacity.hasStorage) {
		[tmpSections addObject:_dict([NSNumber numberWithInt:BUILDING_SECTION_BUILDING], @"type", @"Building", @"name", _array([NSNumber numberWithInt:BUILDING_ROW_BUILDING_STATS], [NSNumber numberWithInt:BUILDING_ROW_STORAGE]), @"rows")];
	} else {
		[tmpSections addObject:_dict([NSNumber numberWithInt:BUILDING_SECTION_BUILDING], @"type", @"Building", @"name", _array([NSNumber numberWithInt:BUILDING_ROW_BUILDING_STATS]), @"rows")];
	}


	[self parseAdditionalData:data tmpSections:tmpSections];
	
	NSMutableArray *tmpArray = _array([NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_STATS]);
	if (self.upgradedResourceStorage.hasStorage) {
		[tmpArray addObject:[NSNumber numberWithInt:BUILDING_ROW_UPGRADE_STORAGE]];
	}

	if (self.pendingBuild && (id)self.pendingBuild != [NSNull null]) {
		[tmpArray addObject:[NSNumber numberWithInt:BUILDING_ROW_UPGRADE_PROGRESS]];
	} else {
		[tmpArray addObject:[NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_COST]];
		if (self.canUpgrade) {
			[tmpArray addObject:[NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUTTON]];
		} else {
			[tmpArray addObject:[NSNumber numberWithInt:BUILDING_ROW_UPGRADE_CANNOT]];
		}
		[tmpArray addObject:[NSNumber numberWithInt:BUILDING_ROW_DEMOLISH_BUTTON]];
	}
	[tmpSections addObject:_dict([NSNumber numberWithInt:BUILDING_SECTION_UPGRADE], @"type", @"Upgrade", @"name", tmpArray, @"rows")];
	
	self.sections = tmpSections;
	
}


- (void)parseAdditionalData:(NSDictionary *)data tmpSections:(NSMutableArray *)tmpSections {
	//Does nothing. You should override this for building specific functions
}


- (void)tick:(NSInteger)interval {
	[self.pendingBuild tick:interval];
	if (self.pendingBuild && self.pendingBuild.secondsRemaining <= 0) {
		self.needsReload = YES;
	}
}


- (NSInteger)sectionCount {
	return [self.sections count];
}


- (NSInteger)numRowsInSection:(NSInteger)section {
	return [[[self.sections objectAtIndex:section] objectForKey:@"rows"] count];
}


- (NSArray *)sectionHeadersForTableView:(UITableView *)tableView {
	NSMutableArray *sectionTabs = [NSMutableArray arrayWithCapacity:[self.sections count]];
	for (NSDictionary *section in self.sections) {
		[sectionTabs addObject:[LEViewSectionTab tableView:tableView createWithText:[section objectForKey:@"name"]]];
	}
	return sectionTabs;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	return [self tableView:tableView heightForBuildingRow:_intv([rows objectAtIndex:indexPath.row])];
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_BUILDING_STATS:
			return 100.0;
			break;
		case BUILDING_ROW_UPGRADE_BUILDING_STATS:
			return 100.0;
			break;
		case BUILDING_ROW_UPGRADE_BUILDING_COST:
			return 65.0;
			break;
		case BUILDING_ROW_UPGRADE_BUTTON:
		case BUILDING_ROW_DEMOLISH_BUTTON:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_UPGRADE_CANNOT:
			return 88.0;
			break;
		case BUILDING_ROW_UPGRADE_PROGRESS:
			return 50.0;
			break;
		case BUILDING_ROW_EMPTY:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_STORAGE:
		case BUILDING_ROW_UPGRADE_STORAGE:
			return [LETableViewCellBuildingStorage getHeightForTableView:tableView];
			break;
		default:
			return tableView.rowHeight;
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
    return [self tableView:tableView cellForBuildingRow:_intv([rows objectAtIndex:indexPath.row]) rowIndex:indexPath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	Session *session = [Session sharedInstance];
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_BUILDING_STATS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellBuildingStats *statsCell = [LETableViewCellBuildingStats getCellForTableView:tableView];
			[statsCell setBuildingImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", self.imageName]]];
			[statsCell setBuildingBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", session.body.surfaceImageName]]];
			[statsCell setBuildingName:self.name buildingLevel:self.level];
			[statsCell setResourceGeneration:self.resourcesPerHour];
			cell = statsCell;
			break;
		case BUILDING_ROW_UPGRADE_BUILDING_STATS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellBuildingStats *upgradeStatsCell = [LETableViewCellBuildingStats getCellForTableView:tableView];
			[upgradeStatsCell setBuildingImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", self.upgradedImageName]]];
			[upgradeStatsCell setBuildingBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", session.body.surfaceImageName]]];
			[upgradeStatsCell setBuildingName:self.name buildingLevel:self.level+1];
			[upgradeStatsCell setResourceGeneration:self.upgradedResourcePerHour];
			cell = upgradeStatsCell;
			break;
		case BUILDING_ROW_UPGRADE_BUILDING_COST:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellCost *costCell = [LETableViewCellCost getCellForTableView:tableView];
			[costCell setResourceCost:self.upgradeCost];
			cell = costCell;
			break;
		case BUILDING_ROW_UPGRADE_CANNOT:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellUnbuildable *unbuildableCell = [LETableViewCellUnbuildable getCellForTableView:tableView];
			if ([self.cannotUpgradeReason isKindOfClass:[NSArray class]]) {
				if ([self.cannotUpgradeReason count] > 2) {
					[unbuildableCell setReason:[NSString stringWithFormat:@"%@ (%@)", [self.cannotUpgradeReason objectAtIndex:1], [self.cannotUpgradeReason objectAtIndex:2]]];
				} else {
					[unbuildableCell setReason:[NSString stringWithFormat:@"%@", [self.cannotUpgradeReason objectAtIndex:1]]];
				}
			} else {
				[unbuildableCell setReason:[NSString stringWithFormat:@"%@", self.cannotUpgradeReason]];
			}
			
			cell = unbuildableCell;
			break;
		case BUILDING_ROW_UPGRADE_PROGRESS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellProgress *pendingCell = [LETableViewCellProgress getCellForTableView:tableView];
			[pendingCell bindToTimedActivity:self.pendingBuild];
			cell = pendingCell;
			break;
		case BUILDING_ROW_UPGRADE_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *upgradeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			upgradeButtonCell.textLabel.text = @"Upgrade";
			cell = upgradeButtonCell;
			break;
		case BUILDING_ROW_DEMOLISH_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *demolishCell = [LETableViewCellButton getCellForTableView:tableView];
			demolishCell.textLabel.text = @"Demolish";
			cell = demolishCell;
			break;
		case BUILDING_ROW_EMPTY:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			emptyCell.label.text = @"";
			emptyCell.content.text = @"Empty";
			cell = emptyCell;
			break;
		case BUILDING_ROW_STORAGE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellBuildingStorage *storageCell = [LETableViewCellBuildingStorage getCellForTableView:tableView];
			[storageCell setResourceStorage:self.resourceCapacity];
			cell = storageCell;
			break;
		case BUILDING_ROW_UPGRADE_STORAGE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellBuildingStorage *upgradeStorageCell = [LETableViewCellBuildingStorage getCellForTableView:tableView];
			[upgradeStorageCell setResourceStorage:self.upgradedResourceStorage];
			cell = upgradeStorageCell;
			break;
		default:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *defaultCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			defaultCell.label.text = @"";
			defaultCell.content.text = @"TBD";
			cell = defaultCell;
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	return [self tableView:tableView didSelectBuildingRow:_intv([rows objectAtIndex:indexPath.row]) rowIndex:indexPath.row];
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_UPGRADE_BUTTON:
			[[[LEUpgradeBuilding alloc] initWithCallback:@selector(upgradedBuilding:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			break;
		case BUILDING_ROW_DEMOLISH_BUTTON:
			[[[LEBuildingDemolish alloc] initWithCallback:@selector(buildingDemolished:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			break;
	}
	return nil;
}


- (BOOL)isDemolishCell:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	return (_intv([rows objectAtIndex:indexPath.row]) == BUILDING_ROW_DEMOLISH_BUTTON);
}


/*
#pragma mark -
#pragma mark Callbacks

- (id)bodyDataLoaded:(LEBuildingView *)request {
	self.buildingData = request.building;
	self.resultData = [request.response objectForKey:@"result"];
	
	self.navigationItem.title = [self.buildingData objectForKey:@"name"];
	
	NSMutableArray *tmpSectionHeaders = [NSMutableArray arrayWithCapacity:5];
	[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Building"]];
	NSMutableArray *tmpSections = [NSMutableArray arrayWithCapacity:5];
	[tmpSections addObject:_dict([NSNumber numberWithInt:SECTION_BUILDING], @"type", _array([NSNumber numberWithInt:ROW_BUILDING_STATS]), @"rows")];
	
	
	if ([self.urlPart isEqualToString:@"/network19"]) {
		[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Actions"]];
		NSMutableArray *rows = [NSMutableArray arrayWithCapacity:5];
		[rows addObject:[NSNumber numberWithInt:ROW_VIEW_NETWORK_19]];
		BOOL restricted = [[[request.response objectForKey:@"result"] objectForKey:@"restrict_coverage"] boolValue];
		if (restricted) {
			[rows addObject:[NSNumber numberWithInt:ROW_RESTRICTED_NETWORK_19]];
		} else {
			[rows addObject:[NSNumber numberWithInt:ROW_UNRESTRICTED_NETWORK_19]];
		}
		[tmpSections addObject:_dict([NSNumber numberWithInt:SECTION_ACTIONS], @"type", rows, @"rows")];
	} else 	if ([self.urlPart isEqualToString:@"/intelligence"]) {
		[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Spies"]];
		NSMutableArray *rows = [NSMutableArray arrayWithCapacity:5];
		[rows addObject:[NSNumber numberWithInt:ROW_NUM_SPIES]];
		[rows addObject:[NSNumber numberWithInt:ROW_SPY_BUILD_COST]];
		
		NSInteger current = _intv([[self.resultData objectForKey:@"spies"] objectForKey:@"current"]);
		NSInteger max = _intv([[self.resultData objectForKey:@"spies"] objectForKey:@"maximum"]);
		if (current < max) {
			[rows addObject:[NSNumber numberWithInt:ROW_BUILD_SPY_BUTTON]];
		}
		
		[rows addObject:[NSNumber numberWithInt:ROW_VIEW_SPIES_BUTTON]];
		[tmpSections addObject:_dict([NSNumber numberWithInt:SECTION_ACTIONS], @"type", rows, @"rows")];
	} else 	if ([self.urlPart isEqualToString:@"/wasterecycling"]) {
		[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Actions"]];
		NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
		
		NSInteger canRecycle = _intv([[self.resultData objectForKey:@"recycle"] objectForKey:@"can"]);
		if (canRecycle) {
			[rows addObject:[NSNumber numberWithInt:ROW_RECYCLE]];
		} else {
			[rows addObject:[NSNumber numberWithInt:ROW_RECYCLE_PENDING]];
			[rows addObject:[NSNumber numberWithInt:ROW_SUBSIDIZE]];
		}
		
		[tmpSections addObject:_dict([NSNumber numberWithInt:SECTION_ACTIONS], @"type", rows, @"rows")];
	} else 	if ([self.urlPart isEqualToString:@"/park"]) {
		[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Party"]];
		NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
		
		NSInteger canRecycle = _intv([[self.resultData objectForKey:@"party"] objectForKey:@"can_throw"]);
		if (canRecycle) {
			[rows addObject:[NSNumber numberWithInt:ROW_THROW_PARTY]];
		} else {
			[rows addObject:[NSNumber numberWithInt:ROW_PARTY_PENDING]];
		}
		
		[tmpSections addObject:_dict([NSNumber numberWithInt:SECTION_ACTIONS], @"type", rows, @"rows")];
	} else 	if ([self.urlPart isEqualToString:@"/development"]) {
		if ([self.resultData objectForKey:@"build_queue"]) {
			[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Build Queue"]];
			NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
			
			self->subsidyBuildQueueCost = _intv([self.resultData objectForKey:@"subsidy_cost"]);
			NSArray *buildQueue = [self.resultData objectForKey:@"build_queue"];
			NSInteger buildQueueSize = [buildQueue count];
			if (buildQueueSize > 0) {
				for (int i=0; i<buildQueueSize; i++) {
					[rows addObject:[NSNumber numberWithInt:ROW_BUILD_QUEUE_ITEM]];
				}
				[rows addObject:[NSNumber numberWithInt:ROW_SUBSIDIZE_BUILD_QUEUE]];
			} else {
				[rows addObject:[NSNumber numberWithInt:ROW_EMPTY]];
			}
			
			
			[tmpSections addObject:_dict([NSNumber numberWithInt:SECTION_ACTIONS], @"type", rows, @"rows")];
		}
	}
	
	
	[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView createWithText:@"Upgrade"]];
	NSDictionary *pendingBuild = [self.buildingData objectForKey:@"pending_build"];
	if (pendingBuild && (id)pendingBuild != [NSNull null]) {
		[tmpSections addObject:_dict([NSNumber numberWithInt:SECTION_UPGRADE], @"type", _array([NSNumber numberWithInt:ROW_UPGRADE_BUILDING_STATS], [NSNumber numberWithInt:ROW_UPGRADE_PROGRESS]), @"rows")];
		NSDate *buildEndDate = [Util date:[pendingBuild objectForKey:@"end"]];
		NSDate *buildStartDate = [Util date:[pendingBuild objectForKey:@"start"]];
		totalBuildTime = (NSInteger)[buildEndDate timeIntervalSinceDate:buildStartDate];
		remainingBuildTime = _intv([pendingBuild objectForKey:@"seconds_remaining"]);
	} else {
		NSDictionary *upgrade = [self.buildingData objectForKey:@"upgrade"];
		BOOL canUpgrade = [[upgrade objectForKey:@"can"] boolValue];
		totalBuildTime = 0;
		remainingBuildTime = 0;
		if (canUpgrade) {
			[tmpSections addObject:_dict([NSNumber numberWithInt:SECTION_UPGRADE], @"type", _array([NSNumber numberWithInt:ROW_UPGRADE_BUILDING_STATS], [NSNumber numberWithInt:ROW_UPGRADE_BUILDING_COST], [NSNumber numberWithInt:ROW_UPGRADE_BUTTON], [NSNumber numberWithInt:ROW_DEMOLISH_BUTTON]), @"rows")];
		} else {
			[tmpSections addObject:_dict([NSNumber numberWithInt:SECTION_UPGRADE], @"type", _array([NSNumber numberWithInt:ROW_UPGRADE_BUILDING_STATS], [NSNumber numberWithInt:ROW_UPGRADE_BUILDING_COST], [NSNumber numberWithInt:ROW_UPGRADE_CANNOT], [NSNumber numberWithInt:ROW_DEMOLISH_BUTTON]), @"rows")];
		}
	}
	
	self.sectionHeaders = tmpSectionHeaders;
	self.sections = tmpSections;
	
	[self.tableView reloadData];
	
	return nil;
}
*/


- (id)upgradedBuilding:(LEUpgradeBuilding *)request {
	NSDictionary *pendingBuildDict = [request.buildingData objectForKey:@"pending_build"]; 
	if ( pendingBuildDict && ((id)pendingBuildDict != [NSNull null]) ) {
		for (NSMutableDictionary *section in self.sections) {
			if ([[section objectForKey:@"type"] isEqual:[NSNumber numberWithInt:BUILDING_SECTION_UPGRADE]]) {
				[section setObject:_array([NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_STATS], [NSNumber numberWithInt:BUILDING_ROW_UPGRADE_PROGRESS]) forKey:@"rows"];
			}
		}
		if(!self.pendingBuild) {
			TimedActivity *timedActivity = [[[TimedActivity alloc] init] autorelease];
			[timedActivity parseData:pendingBuildDict];
			self.pendingBuild = timedActivity;
		} else {
			[self.pendingBuild parseData:pendingBuildDict];
		}
		self.canUpgrade = NO;
	} else {
		for (NSMutableDictionary *section in self.sections) {
			if ([[section objectForKey:@"type"] isEqual:[NSNumber numberWithInt:BUILDING_SECTION_UPGRADE]]) {
				NSLog(@"Is not Building");
				if (self.canUpgrade) {
					NSLog(@"Can upgrade");
					[section setObject:_array([NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_STATS], [NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_COST], [NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUTTON], [NSNumber numberWithInt:BUILDING_ROW_DEMOLISH_BUTTON]) forKey:@"rows"];
				} else {
					NSLog(@"Can NOT upgrade");
					[section setObject:_array([NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_STATS], [NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_COST], [NSNumber numberWithInt:BUILDING_ROW_UPGRADE_CANNOT], [NSNumber numberWithInt:BUILDING_ROW_DEMOLISH_BUTTON]) forKey:@"rows"];
				}
			}
		}
		self.pendingBuild = nil;
	}
	
	return nil;
}


- (id)buildingDemolished:(LEBuildingDemolish *)request {
	self.demolished = YES;
	return nil;
}

 
#pragma mark -
#pragma mark LETableViewBuildProgressCellDelegate Methods

- (void)progressComplete {
	NSLog(@"Progress Complete!");
}


@end
