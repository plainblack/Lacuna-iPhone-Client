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


@class LEBuildingUpgrade;
@class MapBuilding;


@interface Building : NSObject {
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *buildingUrl;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *imageName;
@property (nonatomic, retain) NSDecimalNumber *level;
@property (nonatomic, retain) NSDecimalNumber *x;
@property (nonatomic, retain) NSDecimalNumber *y;
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
@property (nonatomic, retain) NSDecimalNumber *efficiency;
@property (nonatomic, retain) ResourceCost *repairCost;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, assign) BOOL demolished;
@property (nonatomic, assign) BOOL needsReload;
@property (nonatomic, assign) BOOL needsRefresh;
@property (nonatomic, assign) NSDecimalNumber *population;


- (void)parseData:(NSDictionary *)data;
- (void)parseAdditionalData:(NSDictionary *)data;
- (void)parseWorkData:(NSDictionary *)workData;
- (void)generateDestroyedSections;
- (void)generateSections;
- (NSMutableDictionary *)generateProductionSection;
- (NSMutableDictionary *)generateHealthSection;
- (NSMutableDictionary *)generateUpgradeSection;
- (NSMutableDictionary *)generateGeneralInfoSection;
- (BOOL)tick:(NSInteger)interval;
- (MapBuilding *)findMapBuilding;

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
- (NSString *)confirmMessage:(NSIndexPath *)indexPath;
- (id)buildingUpgrading:(LEBuildingUpgrade *)request;
	
@end
