//
//  LETableViewCellPlanType.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/19/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellPlanType : UITableViewCell {
}


@property(nonatomic, retain) UILabel *name;
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UIImageView *backImageView;


- (void)setPlanType:(NSMutableDictionary *)planType;


+ (LETableViewCellPlanType *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
