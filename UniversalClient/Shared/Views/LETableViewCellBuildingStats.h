//
//  LETableViewCellBuildingStats.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceGeneration.h"


@interface LETableViewCellBuildingStats : UITableViewCell {
}


@property(nonatomic, retain) IBOutlet UILabel *energyPerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *foodPerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *happinessPerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *orePerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *wastePerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *waterPerHourLabel;
@property(nonatomic, retain) IBOutlet UIImageView *buildingImageView;
@property(nonatomic, retain) IBOutlet UIImageView *buildingBackgroundImageView;
@property(nonatomic, retain) IBOutlet UILabel *buildingLevelLabel;


- (void)setEnergyPerHour:(NSDecimalNumber *)perHour;
- (void)setFoodPerHour:(NSDecimalNumber *)perHour;
- (void)setHappinessPerHour:(NSDecimalNumber *)perHour;
- (void)setOrePerHour:(NSDecimalNumber *)perHour;
- (void)setWastePerHour:(NSDecimalNumber *)perHour;
- (void)setWaterPerHour:(NSDecimalNumber *)perHour;
- (void)setBuildingImage:(UIImage *)buildingImage;
- (void)setBuildingBackgroundImage:(UIImage *)buildingImage;
- (void)setBuildingLevel:(NSDecimalNumber *)level;
- (void)setResourceGeneration:(ResourceGeneration *)resourceGeneration;

+ (LETableViewCellBuildingStats *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
