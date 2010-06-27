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


@interface Building : NSObject {
	NSString *id;
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
	NSString *cannotUpgradeReason;
	ResourceCost *upgradeCost;
	ResourceGeneration *upgradedResourcePerHour;
	ResourceStorage *upgradedResourceStorage;
	NSString *upgradedImageName;
}


@property (nonatomic, retain) NSString *id;
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
@property (nonatomic, retain) NSString *cannotUpgradeReason;
@property (nonatomic, retain) ResourceCost *upgradeCost;
@property (nonatomic, retain) ResourceGeneration *upgradedResourcePerHour;
@property (nonatomic, retain) ResourceStorage *upgradedResourceStorage;
@property (nonatomic, retain) NSString *upgradedImageName;


- (void)parseData:(NSDictionary *)data;
- (void)tick:(NSTimeInterval)interval;

- (NSInteger)sectionCount;
- (NSInteger)numRowsInSection:(NSInteger)section;
- (NSArray *)sectionHeadersForTableView:(UITableView *)tableView;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

	
@end
