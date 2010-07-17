//
//  LETableViewCellBuildQueueItem.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellBuildQueueItem : UITableViewCell {
	UILabel *buildingNameText;
	UILabel *levelLabel;
	UILabel *levelText;
	UILabel *durationLabel;
	UILabel *durationText;
}


@property(nonatomic, retain) UILabel *buildingNameText;
@property(nonatomic, retain) UILabel *levelLabel;
@property(nonatomic, retain) UILabel *levelText;
@property(nonatomic, retain) UILabel *durationLabel;
@property(nonatomic, retain) UILabel *durationText;


- (void)setData:(NSDictionary *)data;


+ (LETableViewCellBuildQueueItem *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
