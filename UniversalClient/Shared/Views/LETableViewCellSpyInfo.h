//
//  LETableViewCellSpyInfo.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellSpyInfo : UITableViewCell {
	UILabel *nameContent;
	UILabel *locationContent;
	UILabel *assignmentContent;
}


@property(nonatomic, retain) UILabel *nameContent;
@property(nonatomic, retain) UILabel *locationContent;
@property(nonatomic, retain) UILabel *assignmentContent;


- (void)setData:(NSDictionary *)spyData;


+ (LETableViewCellSpyInfo *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
