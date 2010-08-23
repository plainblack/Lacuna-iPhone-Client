//
//  LETableViewCellLabeledTextCell.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellLabeledText : UITableViewCell {
	UILabel *label;
	UILabel *content;
}


@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UILabel *content;


+ (LETableViewCellLabeledText *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
