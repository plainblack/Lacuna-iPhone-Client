//
//  LETableViewCellBuildingStats.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellBuildingStats : UITableViewCell {
	UILabel *energyPerHourLabel;
	UILabel *foodPerHourLabel;
	UILabel *happinessPerHourLabel;
	UILabel *orePerHourLabel;
	UILabel *wastePerHourLabel;
	UILabel *waterPerHourLabel;
	UIImageView *buildingImageView;
	UILabel *buildingNameAndLevelLabel;
}


@property(nonatomic, retain) IBOutlet UILabel *energyPerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *foodPerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *happinessPerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *orePerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *wastePerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *waterPerHourLabel;
@property(nonatomic, retain) IBOutlet UIImageView *buildingImageView;
@property(nonatomic, retain) IBOutlet UILabel *buildingNameAndLevelLabel;


- (void)setEnergyPerHour:(NSNumber *)perHour;
- (void)setFoodPerHour:(NSNumber *)perHour;
- (void)setHappinessPerHour:(NSNumber *)perHour;
- (void)setOrePerHour:(NSNumber *)perHour;
- (void)setWastePerHour:(NSNumber *)perHour;
- (void)setWaterPerHour:(NSNumber *)perHour;
- (void)setBuildingImage:(UIImage *)buildingImage;
- (void)setBuildingName:(NSString *)name buildingLevel:(NSNumber *)level;


+ (LETableViewCellBuildingStats *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
