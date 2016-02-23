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
#import "Util.h"
#import "Session.h"
#import "MapBuilding.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellBuildingStats.h"
#import "LETableViewCellCost.h"
#import "LETableViewCellUnbuildable.h"
#import "LETableViewCellProgress.h"
#import "LETableViewCellBuildingStorage.h"
#import "LETableViewCellParagraph.h"
#import "LEBuildingUpgrade.h"
#import "LEBuildingDemolish.h"
#import "LEBuildingDowngrade.h"
#import "LEBuildingRestrictCoverage.h"
#import "LEBuildingTrainSpy.h"
#import "LEBuildingSubsidizeBuildQueue.h"
#import "LEBuildingThrowParty.h"
#import "ViewSpiesController.h"
#import "LEBuildingRepair.h"
#import "WebPageController.h"


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
@synthesize efficiency;
@synthesize repairCost;
@synthesize sections;
@synthesize demolished;
@synthesize needsReload;
@synthesize needsRefresh;
@synthesize population;


#pragma mark -
#pragma mark NSObject Methods

- (void)dealloc {
	self.id = nil;
	self.buildingUrl = nil;
	self.name = nil;
	self.imageName = nil;
	self.level = nil;
	self.x = nil;
	self.y = nil;
	self.resourcesPerHour = nil;
	self.resourceCapacity = nil;
	self.pendingBuild = nil;
	self.work = nil;
	self.cannotUpgradeReason = nil;
	self.upgradeCost = nil;
	self.upgradedResourcePerHour = nil;
	self.upgradedResourceStorage = nil;
	self.upgradedImageName = nil;
	self.repairCost = nil;
	self.efficiency = nil;
	self.sections = nil;
    self.population = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	NSDictionary *buildingData = [data objectForKey:@"building"];

	self.id = [Util idFromDict:buildingData named:@"id"];
	self.name = [buildingData objectForKey:@"name"];
	self.imageName = [buildingData objectForKey:@"image"];
	self.level = [Util asNumber:[buildingData objectForKey:@"level"]];
	self.x = [Util asNumber:[buildingData objectForKey:@"x"]];
	self.y = [Util asNumber:[buildingData objectForKey:@"y"]];

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
	
	[self parseWorkData:[buildingData objectForKey:@"work"]];

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
	
	self.efficiency = [Util asNumber:[buildingData objectForKey:@"efficiency"]];
	if (!self.repairCost) {
		self.repairCost = [[[ResourceCost alloc] init] autorelease];
	}
	[self.repairCost parseData:[buildingData objectForKey:@"repair_costs"]];
	
	[self parseAdditionalData:data];
	
	if (_intv(self.efficiency) == 0) {
		[self generateDestroyedSections];
	} else {
		[self generateSections];
	}
}


- (void)parseAdditionalData:(NSDictionary *)data {
	//Does nothing. You should override this for building specific functions
}


- (void)parseWorkData:(NSDictionary *)workData {
	if(!self.work) {
		self.work = [[[TimedActivity alloc] init] autorelease];
	}
	[self.work parseData:workData];
}


- (void)generateDestroyedSections {
	self.sections = _array([self generateHealthSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_DEMOLISH_BUTTON]), @"rows"));
}


- (void)generateSections {
	self.sections = _array([self generateProductionSection], [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (NSMutableDictionary *)generateProductionSection {
	if (self.resourceCapacity.hasStorage) {
		return _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_BUILDING], @"type", @"Production", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_BUILDING_STATS], [NSDecimalNumber numberWithInt:BUILDING_ROW_STORAGE]), @"rows");
	} else {
		return _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_BUILDING], @"type", @"Production", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_BUILDING_STATS]), @"rows");
	}
}


- (NSMutableDictionary *)generateHealthSection {
	if (_intv(self.efficiency) < 100) {
		return _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_HEALTH], @"type", @"Health", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_EFFICENCY], [NSDecimalNumber numberWithInt:BUILDING_ROW_REPAIR_COST], [NSDecimalNumber numberWithInt:BUILDING_ROW_REPAIR_BUTTON]), @"rows");
	} else {
		return _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_HEALTH], @"type", @"Health", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_EFFICENCY]), @"rows");
	}

}


- (NSMutableDictionary *)generateUpgradeSection {
	NSMutableArray *rowArray = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_STATS]);
	if (self.upgradedResourceStorage.hasStorage) {
		[rowArray addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_STORAGE]];
	}
	
	if (self.pendingBuild && (id)self.pendingBuild != [NSNull null]) {
		[rowArray addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_PROGRESS]];
	} else {
		[rowArray addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_COST]];
		if (self.canUpgrade) {
			[rowArray addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_BUTTON]];
		} else {
			[rowArray addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_CANNOT]];
		}
		[rowArray addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_DOWNGRADE_BUTTON]];
	}

	[rowArray addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_DEMOLISH_BUTTON]];
	
	return _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_UPGRADE], @"type", @"Upgrade", @"name", rowArray, @"rows");
}


- (NSMutableDictionary *)generateGeneralInfoSection {
	return _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_GENERAL_INFO], @"type", @"General Info", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_DESCRIPTION], [NSDecimalNumber numberWithInt:BUILDING_ROW_WIKI_BUTTON]), @"rows");
}


- (BOOL)tick:(NSInteger)interval {
	BOOL reloadNeeded = NO;
	[self.pendingBuild tick:interval];
	if (self.pendingBuild) {
		if (self.pendingBuild.secondsRemaining > 0) {
			self.needsRefresh = YES;
		} else {
			reloadNeeded = YES;
		}
	}
	return reloadNeeded;
}


- (MapBuilding *)findMapBuilding {
	Session *session = [Session sharedInstance];
	MapBuilding *mapBuilding = [session.body.buildingMap objectForKey:[NSString stringWithFormat:@"%@x%@", self.x, self.y]];
	return mapBuilding;
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
		[sectionTabs addObject:[LEViewSectionTab tableView:tableView withText:[section objectForKey:@"name"]]];
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
		case BUILDING_ROW_UPGRADE_BUILDING_STATS:
			return [LETableViewCellBuildingStats getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_UPGRADE_BUILDING_COST:
		case BUILDING_ROW_REPAIR_COST:
			return [LETableViewCellCost getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_UPGRADE_BUTTON:
		case BUILDING_ROW_DEMOLISH_BUTTON:
		case BUILDING_ROW_DOWNGRADE_BUTTON:
		case BUILDING_ROW_REPAIR_BUTTON:
		case BUILDING_ROW_WIKI_BUTTON:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_UPGRADE_CANNOT:
			return [LETableViewCellUnbuildable getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_UPGRADE_PROGRESS:
			return [LETableViewCellProgress getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_EMPTY:
		case BUILDING_ROW_EFFICENCY:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_STORAGE:
		case BUILDING_ROW_UPGRADE_STORAGE:
			return [LETableViewCellBuildingStorage getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_DESCRIPTION:
			; //DO NOT REMOVE
			Session *session = [Session sharedInstance];
			return [LETableViewCellParagraph getHeightForTableView:tableView text:[session descriptionForBuilding:self.buildingUrl]];
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
			[upgradeStatsCell setBuildingLevel:[self.level decimalNumberByAdding:[NSDecimalNumber one]]];
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
				[unbuildableCell setReason:[NSString stringWithFormat:@"%@", [self.cannotUpgradeReason objectAtIndex:1]]];
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
		case BUILDING_ROW_DOWNGRADE_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *downgradeCell = [LETableViewCellButton getCellForTableView:tableView];
			downgradeCell.textLabel.text = @"Downgrade";
			cell = downgradeCell;
			break;
		case BUILDING_ROW_EMPTY:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
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
		case BUILDING_ROW_EFFICENCY:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *efficencyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			efficencyCell.label.text = @"Efficency";
			efficencyCell.content.text = [NSString stringWithFormat:@"%@%%", self.efficiency];
			cell = efficencyCell;
			break;
		case BUILDING_ROW_REPAIR_COST:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellCost *repairCostCell = [LETableViewCellCost getCellForTableView:tableView];
			[repairCostCell setResourceCost:self.repairCost];
			cell = repairCostCell;
			break;
		case BUILDING_ROW_REPAIR_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *repairButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			repairButtonCell.textLabel.text = @"Repair";
			cell = repairButtonCell;
			break;
		case BUILDING_ROW_DESCRIPTION:
			; //DO NOT REMOVE
			Session *session = [Session sharedInstance];
			NSString *description = [session descriptionForBuilding:self.buildingUrl];
			LETableViewCellParagraph *descriptionCell = [LETableViewCellParagraph getCellForTableView:tableView];
			descriptionCell.content.text = description;
			cell = descriptionCell;
			break;
		case BUILDING_ROW_WIKI_BUTTON:
			; //DO NOT REMOVE
			LETableViewCellButton *wikiCell = [LETableViewCellButton getCellForTableView:tableView];
			wikiCell.textLabel.text = @"View Wiki Page";
			cell = wikiCell;
			break;
		default:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *defaultCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
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
			[[[LEBuildingUpgrade alloc] initWithCallback:@selector(buildingUpgrading:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		case BUILDING_ROW_DEMOLISH_BUTTON:
			[[[LEBuildingDemolish alloc] initWithCallback:@selector(buildingDemolished:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		case BUILDING_ROW_DOWNGRADE_BUTTON:
			[[[LEBuildingDowngrade alloc] initWithCallback:@selector(buildingDowngraded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		case BUILDING_ROW_REPAIR_BUTTON:
			[[[LEBuildingRepair alloc] initWithCallback:@selector(buildingRepaired:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		case BUILDING_ROW_WIKI_BUTTON:
			; //DO NOT REMOVE
			Session *session = [Session sharedInstance];
			NSString *url = [session wikiLinkForBuilding:self.buildingUrl];
			WebPageController *webPageController = [WebPageController create];
			webPageController.urlToLoad = url;
			return webPageController;
			break;
		default:
			return nil;
			break;
	}
}


- (BOOL)isConfirmCell:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	return (_intv([rows objectAtIndex:indexPath.row]) == BUILDING_ROW_DEMOLISH_BUTTON) ||
			(_intv([rows objectAtIndex:indexPath.row]) == BUILDING_ROW_DOWNGRADE_BUTTON);
}


- (NSString *)confirmMessage:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	switch (_intv([rows objectAtIndex:indexPath.row])) {
		case BUILDING_ROW_DEMOLISH_BUTTON:
			return @"Are you sure you want to demolish this building?";
			break;
		case BUILDING_ROW_DOWNGRADE_BUTTON:
			return @"Are you sure you want to downgrade this building by one level?";
			break;
		default:
			return @"Are you sure?";
			break;
	}
}


- (id)buildingUpgrading:(LEBuildingUpgrade *)request {
	NSDictionary *pendingBuildDict = [request.buildingData objectForKey:@"pending_build"]; 
	if (isNotNull(pendingBuildDict)) {
		for (NSMutableDictionary *section in self.sections) {
			if ([[section objectForKey:@"type"] isEqual:[NSDecimalNumber numberWithInt:BUILDING_SECTION_UPGRADE]]) {
				[section setObject:_array([NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_STATS], [NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_PROGRESS], [NSDecimalNumber numberWithInt:BUILDING_ROW_DEMOLISH_BUTTON]) forKey:@"rows"];
			}
		}
		if(!self.pendingBuild) {
			TimedActivity *timedActivity = [[[TimedActivity alloc] init] autorelease];
			[timedActivity parseData:pendingBuildDict];
			self.pendingBuild = timedActivity;
		} else {
			[self.pendingBuild parseData:pendingBuildDict];
		}
		
		MapBuilding *mapBuilding = [self findMapBuilding];
		[mapBuilding updatePendingBuild:pendingBuildDict];
		
		self.canUpgrade = NO;
	} else {
		for (NSMutableDictionary *section in self.sections) {
			if ([[section objectForKey:@"type"] isEqual:[NSDecimalNumber numberWithInt:BUILDING_SECTION_UPGRADE]]) {
				if (self.canUpgrade) {
					[section setObject:_array([NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_STATS], [NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_COST], [NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_BUTTON], [NSDecimalNumber numberWithInt:BUILDING_ROW_DEMOLISH_BUTTON], [NSDecimalNumber numberWithInt:BUILDING_ROW_DOWNGRADE_BUTTON]) forKey:@"rows"];
				} else {
					[section setObject:_array([NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_STATS], [NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_BUILDING_COST], [NSDecimalNumber numberWithInt:BUILDING_ROW_UPGRADE_CANNOT], [NSDecimalNumber numberWithInt:BUILDING_ROW_DEMOLISH_BUTTON], [NSDecimalNumber numberWithInt:BUILDING_ROW_DOWNGRADE_BUTTON]) forKey:@"rows"];
				}
			}
		}
		self.pendingBuild = nil;
	}
	self.needsRefresh = YES;
	
	return nil;
}


- (id)buildingDemolished:(LEBuildingDemolish *)request {
	self.demolished = YES;
	return nil;
}


- (id)buildingDowngraded:(LEBuildingDowngrade *)request {
	if ([self.level isEqualToNumber:[NSDecimalNumber one]]) {
		self.demolished = YES;
	} else {
		[self parseData:request.result];
		[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
		self.needsRefresh = YES;
	}
	return nil;
}


- (id)buildingRepaired:(LEBuildingRepair *)request {
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
	self.needsRefresh = YES;
	
	return nil;
}


#pragma mark -
#pragma mark LETableViewBuildProgressCellDelegate Methods

- (void)progressComplete {
	NSLog(@"Progress Complete!");
}


@end
