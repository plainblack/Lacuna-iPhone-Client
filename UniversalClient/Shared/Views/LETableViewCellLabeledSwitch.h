//
//  LETableViewCellLabeledSwitch.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellLabeledSwitch : UITableViewCell {
	UILabel *label;
	UISwitch *selectedSwitch;
}


@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UISwitch *selectedSwitch;


- (BOOL)isSelected;


+ (LETableViewCellLabeledSwitch *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
