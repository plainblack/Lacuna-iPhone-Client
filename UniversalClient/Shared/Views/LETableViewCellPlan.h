//
//  LETableViewCellPlan.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Plan;


@interface LETableViewCellPlan : UITableViewCell {
}


@property(nonatomic, retain) UILabel *name;
@property(nonatomic, retain) UILabel *buildLevel;


- (void)setPlan:(Plan *)plan;


+ (LETableViewCellPlan *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
