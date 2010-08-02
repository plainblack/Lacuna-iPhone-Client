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
		
		self.upgradedImageName = [upgradeData objectForKey:@"image"];
	}
	
	
	[self parseAdditionalData:data];
	
	[self generateSections];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	//Does nothing. You should override this for building specific functions
}


- (void)generateSections {
	self.sections = _array([self generateProductionSection], [self generateUpgradeSection]);
}


- (NSMutableDictionary *)generateProductionSection {
	if (self.resourceCapacity.hasStorage) {
		return _dict([NSNumber numberWithInt:BUILDING_SECTION_BUILDING], @"type", @"Production", @"name", _array([NSNumber numberWithInt:BUILDING_ROW_BUILDING_STATS], [NSNumber numberWithInt:BUILDING_ROW_STORAGE]), @"rows");
	} else {
		return _dict([NSNumber numberWithInt:BUILDING_SECTION_BUILDING], @"type", @"Production", @"name", _array([NSNumber numberWithInt:BUILDING_ROW_BUILDING_STATS]), @"rows");
	}
}


- (NSMutableDictionary *)generateUpgradeSection {
	NSMutableArray *rowArray = _array([NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_STATS]);
	if (self.upgradedResourceStorage.hasStorage) {
		[rowArray addObject:[NSNumber numberWithInt:BUILDING_ROW_UPGRADE_STORAGE]];
	}
	
	if (self.pendingBuild && (id)self.pendingBuild != [NSNull null]) {
		[rowArray addObject:[NSNumber numberWithInt:BUILDING_ROW_UPGRADE_PROGRESS]];
	} else {
		[rowArray addObject:[NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_COST]];
		if (self.canUpgrade) {
			[rowArray addObject:[NSNumber numberWithInt:BUILDING_ROW_UPGRADE_BUTTON]];
		} else {
			[rowArray addObject:[NSNumber numberWithInt:BUILDING_ROW_UPGRADE_CANNOT]];
		}
		[rowArray addObject:[NSNumber numberWithInt:BUILDING_ROW_DEMOLISH_BUTTON]];
	}

	return _dict([NSNumber numberWithInt:BUILDING_SECTION_UPGRADE], @"type", @"Upgrade", @"name", rowArray, @"rows");
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
			return [LETableViewCellBuildingStats getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_UPGRADE_BUILDING_STATS:
			return [LETableViewCellBuildingStats getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_UPGRADE_BUILDING_COST:
			return [LETableViewCellCost getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_UPGRADE_BUTTON:
		case BUILDING_ROW_DEMOLISH_BUTTON:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_UPGRADE_CANNOT:
			return [LETableViewCellUnbuildable getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_UPGRADE_PROGRESS:
			return [LETableViewCellProgress getHeightForTableView:tableView];
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
			[statsCell setBuildingLevel:self.level];
			[statsCell setResourceGeneration:self.resourcesPerHour];
			cell = statsCell;
			break;
		case BUILDING_ROW_UPGRADE_BUILDING_STATS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellBuildingStats *upgradeStatsCell = [LETableViewCellBuildingStats getCellForTableView:tableView];
			[upgradeStatsCell setBuildingImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", self.upgradedImageName]]];
			[upgradeStatsCell setBuildingBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", session.body.surfaceImageName]]];
			[upgradeStatsCell setBuildingLevel:self.level+1];
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


- (BOOL)isConfirmCell:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	return (_intv([rows objectAtIndex:indexPath.row]) == BUILDING_ROW_DEMOLISH_BUTTON);
}


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
