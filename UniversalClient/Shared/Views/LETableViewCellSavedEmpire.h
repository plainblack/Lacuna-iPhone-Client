//
//  LETableViewCellSavedEmpire.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellSavedEmpire : UITableViewCell {
	UILabel *empireNameText;
	UILabel *serverUriLabel;
}


@property(nonatomic, retain) UILabel *empireNameText;
@property(nonatomic, retain) UILabel *serverUriLabel;


- (void)setData:(NSDictionary *)data;


+ (LETableViewCellSavedEmpire *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
