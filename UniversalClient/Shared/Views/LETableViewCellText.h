//
//  LETableViewCellText.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellText : UITableViewCell {
	UILabel *content;

}


@property(nonatomic, retain) UILabel *content;


+ (LETableViewCellText *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
