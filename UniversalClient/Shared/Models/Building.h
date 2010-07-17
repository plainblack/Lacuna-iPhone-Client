//
//  Building.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceCost.h"
#import "ResourceGeneration.h"
#import "ResourceStorage.h"
#import "TimedActivity.h"
#import "BuildingUtil.h"


@interface Building : NSObject {
	NSString *id;
	NSString *buildingUrl;
	NSString *name;
	NSString *imageName;
	NSInteger level;
	NSInteger x;
	NSInteger y;
	ResourceGeneration *resourcesPerHour;
	ResourceStorage *resourceCapacity;
	TimedActivity *pendingBuild;
	TimedActivity *work;
	BOOL canUpgrade;
	NSArray *cannotUpgradeReason;
	ResourceCost *upgradeCost;
	ResourceGeneration *upgradedResourcePerHour;
	ResourceStorage *upgradedResourceStorage;
	NSString *upgradedImageName;
	NSMutableArray *sections;
	NSInteger subsidyBuildQueueCost;
	BOOL demolished;
	BOOL needsReload;
	BOOL needsRefresh;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, retain) ResourceGeneration *resourcesPerHour;
@property (nonatomic, retain) ResourceStorage *resourceCapacity;
@property (nonatomic, retain) TimedActivity *pendingBuild;
@property (nonatomic, retain) TimedActivity *work;
@property (nonatomic, assign) BOOL canUpgrade;
@property (nonatomic, retain) NSArray *cannotUpgradeReason;
@property (nonatomic, retain) ResourceCost *upgradeCost;
@property (nonatomic, retain) ResourceGeneration *upgradedResourcePerHour;
@property (nonatomic, retain) ResourceStorage *upgradedResourceStorage;
@property (nonatomic, retain) NSString *upgradedImageName;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, assign) BOOL demolished;
@property (nonatomic, assign) BOOL needsReload;
@property (nonatomic, assign) BOOL needsRefresh;


- (void)parseData:(NSDictionary *)data;
- (void)parseAdditionalData:(NSDictionary *)data tmpSections:(NSMutableArray *)tmpSections;
- (void)tick:(NSInteger)interval;

- (NSInteger)sectionCount;
- (NSInteger)numRowsInSection:(NSInteger)section;
- (NSArray *)sectionHeadersForTableView:(UITableView *)tableView;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buldingRow;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex;
- (UIViewController *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex;
- (BOOL)isConfirmCell:(NSIndexPath *)indexPath;

	
@end
