//
//  LETableViewCellCurrentResources.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Body.h"


@interface LETableViewCellCurrentResources : UITableViewCell {
	UILabel *energyTotalLabel;
	UILabel *energyPerHourLabel;
	UILabel *foodTotalLabel;
	UILabel *foodPerHourLabel;
	UILabel *happinessTotalLabel;
	UILabel *happinessPerHourLabel;
	UILabel *oreTotalLabel;
	UILabel *orePerHourLabel;
	UILabel *wasteTotalLabel;
	UILabel *wastePerHourLabel;
	UILabel *waterTotalLabel;
	UILabel *waterPerHourLabel;
}


@property(nonatomic, retain) IBOutlet UILabel *energyTotalLabel;
@property(nonatomic, retain) IBOutlet UILabel *energyPerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *foodTotalLabel;
@property(nonatomic, retain) IBOutlet UILabel *foodPerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *happinessTotalLabel;
@property(nonatomic, retain) IBOutlet UILabel *happinessPerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *oreTotalLabel;
@property(nonatomic, retain) IBOutlet UILabel *orePerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *wasteTotalLabel;
@property(nonatomic, retain) IBOutlet UILabel *wastePerHourLabel;
@property(nonatomic, retain) IBOutlet UILabel *waterTotalLabel;
@property(nonatomic, retain) IBOutlet UILabel *waterPerHourLabel;


- (void)showBodyData:(Body *)body;


+ (LETableViewCellCurrentResources *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
