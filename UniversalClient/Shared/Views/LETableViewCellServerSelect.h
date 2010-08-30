//
//  LETableViewCellServerSelect.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellServerSelect : UITableViewCell {
	UILabel *nameLabel;
	UILabel *locationLabel;
	UILabel *statusLabel;
}


@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) UILabel *locationLabel;
@property(nonatomic, retain) UILabel *statusLabel;


- (void)setServer:(NSDictionary *)serverData;


+ (LETableViewCellServerSelect *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
