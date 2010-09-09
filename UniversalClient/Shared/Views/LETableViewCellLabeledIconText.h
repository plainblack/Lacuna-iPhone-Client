//
//  LETableViewCellLabeledIconText.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/9/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellLabeledIconText : UITableViewCell {
	UILabel *label;
	UIImageView *icon;
	UILabel *content;
}


@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIImageView *icon;
@property(nonatomic, retain) UILabel *content;


+ (LETableViewCellLabeledIconText *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
