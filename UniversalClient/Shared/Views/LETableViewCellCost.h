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


- (void)setEnergyCost:(NSDecimalNumber *)cost;
- (void)setFoodCost:(NSDecimalNumber *)cost;
- (void)setTimeCost:(NSDecimalNumber *)cost;
- (void)setOreCost:(NSDecimalNumber *)cost;
- (void)setWasteCost:(NSDecimalNumber *)cost;
- (void)setWaterCost:(NSDecimalNumber *)cost;
- (void)setResourceCost:(ResourceCost *)resourceCost;


+ (LETableViewCellCost *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
