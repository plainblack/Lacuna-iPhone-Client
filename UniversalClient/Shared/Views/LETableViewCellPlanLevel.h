//
//  LETableViewCellPlanLevel.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellPlanLevel : UITableViewCell {
}


@property(nonatomic, retain) IBOutlet UILabel *planLevelLabel;
@property(nonatomic, retain) IBOutlet UILabel *energyCostLabel;
@property(nonatomic, retain) IBOutlet UILabel *foodCostLabel;
@property(nonatomic, retain) IBOutlet UILabel *timeCostLabel;
@property(nonatomic, retain) IBOutlet UILabel *oreCostLabel;
@property(nonatomic, retain) IBOutlet UILabel *wasteCostLabel;
@property(nonatomic, retain) IBOutlet UILabel *waterCostLabel;


- (void)setPlanLevel:(NSMutableDictionary *)planLevel;


+ (LETableViewCellPlanLevel *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;



@end
