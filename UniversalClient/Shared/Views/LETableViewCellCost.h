//
//  LETableViewCellCost.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceCost.h"


@interface LETableViewCellCost : UITableViewCell {
	UILabel *energyCostLabel;
	UILabel *foodCostLabel;
	UILabel *timeCostLabel;
	UILabel *oreCostLabel;
	UILabel *wasteCostLabel;
	UILabel *waterCostLabel;
}

@property(nonatomic, retain) IBOutlet UILabel *energyCostLabel;
@property(nonatomic, retain) IBOutlet UILabel *foodCostLabel;
@property(nonatomic, retain) IBOutlet UILabel *timeCostLabel;
@property(nonatomic, retain) IBOutlet UILabel *oreCostLabel;
@property(nonatomic, retain) IBOutlet UILabel *wasteCostLabel;
@property(nonatomic, retain) IBOutlet UILabel *waterCostLabel;


- (void)setEnergyCost:(NSNumber *)cost;
- (void)setFoodCost:(NSNumber *)cost;
- (void)setTimeCost:(NSNumber *)cost;
- (void)setOreCost:(NSNumber *)cost;
- (void)setWasteCost:(NSNumber *)cost;
- (void)setWaterCost:(NSNumber *)cost;
- (void)setResourceCost:(ResourceCost *)resourceCost;


+ (LETableViewCellCost *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
