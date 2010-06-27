//
//  Building.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Building.h"
#import "LEMacros.h"
#import "LETableViewCellLabeledText.h"
#import "LEViewSectionTab.h"


@implementation Building


@synthesize id;
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


#pragma mark --
#pragma mark NSObject Methods

- (void)dealloc {
	self.id = nil;
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
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	NSDictionary *buildingData = [data objectForKey:@"building"];
	self.id = [buildingData objectForKey:@"id"];
	self.name = [buildingData objectForKey:@"name"];
	self.imageName = [buildingData objectForKey:@"image"];
	self.level = intv_([buildingData objectForKey:@"level"]);
	self.x = intv_([buildingData objectForKey:@"x"]);
	self.y = intv_([buildingData objectForKey:@"y"]);

	if (!self.resourcesPerHour) {
		self.resourcesPerHour = [[[ResourceGeneration alloc] init] autorelease];
	}
	[self.resourcesPerHour parseData:buildingData];

	if (!self.resourceCapacity) {
		self.resourceCapacity = [[[ResourceStorage alloc] init] autorelease];
	}
	[self.resourceCapacity parseData:buildingData];

	if(!self.pendingBuild) {
		self.pendingBuild = [[[TimedActivity alloc] init] autorelease];
	}
	[self.pendingBuild parseData:[buildingData objectForKey:@"pending_build"] ];

	if(!self.work) {
		self.work = [[[TimedActivity alloc] init] autorelease];
	}
	[self.work parseData:[buildingData objectForKey:@"work"]];

	NSDictionary *upgradeData = [buildingData objectForKey:@"upgrade"];
	if (upgradeData) {
		self.canUpgrade = intv_([buildingData objectForKey:@"can"]);
		self.cannotUpgradeReason = [buildingData objectForKey:@"reason"];
		
		if (!self.upgradeCost) {
			self.upgradeCost = [[[ResourceCost alloc] init] autorelease];
		}
		[self.upgradeCost parseData:[buildingData objectForKey:@"cost"]];
		
		if (!self.upgradedResourcePerHour) {
			self.upgradedResourcePerHour = [[[ResourceGeneration alloc] init] autorelease];
		}
		[self.upgradedResourcePerHour parseData:[buildingData objectForKey:@"production"]];
		
		if (!self.upgradedResourceStorage) {
			self.upgradedResourceStorage = [[[ResourceStorage alloc] init] autorelease];
		}
		[self.upgradedResourceStorage parseData:[buildingData objectForKey:@"production"]];
		
		self.upgradedImageName = [buildingData objectForKey:@"image"];
	}
}


- (void)tick:(NSTimeInterval)interval {
	NSLog(@"Building tick called. Does nothing for now.");
}


- (NSInteger)sectionCount {
	return 1;
}


- (NSInteger)numRowsInSection:(NSInteger)section {
	return 1;
}


- (NSArray *)sectionHeadersForTableView:(UITableView *)tableView {
	return array_([LEViewSectionTab tableView:tableView createWithText:@"WIP"]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [LETableViewCellLabeledText getHeightForTableView:tableView];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView];
	emptyCell.textLabel.text = @"WIP";
	return emptyCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Selected row: %@", indexPath);
}


@end
