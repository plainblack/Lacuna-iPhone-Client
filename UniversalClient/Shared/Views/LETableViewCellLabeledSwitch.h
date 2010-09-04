//
//  LETableViewCellLabeledSwitch.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LETableViewCellLabeledSwitch;


@protocol LETableViewCellLabeledSwitchDelegate

- (void)cell:(LETableViewCellLabeledSwitch *)cell switchedTo:(BOOL)isOn;

@end


@interface LETableViewCellLabeledSwitch : UITableViewCell {
	UILabel *label;
	UISwitch *selectedSwitch;
	BOOL isSelected;
	id<LETableViewCellLabeledSwitchDelegate> delegate;
}


@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UISwitch *selectedSwitch;
@property(nonatomic, assign) BOOL isSelected;
@property(nonatomic, assign) id<LETableViewCellLabeledSwitchDelegate> delegate;


+ (LETableViewCellLabeledSwitch *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
