//
//  LETableViewCellLongLabeledText.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellLongLabeledText : UITableViewCell {
	UILabel *label;
	UILabel *content;
}


@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UILabel *content;


+ (LETableViewCellLongLabeledText *)getCellForTableView:(UITableView *)tableView isSelectable:(BOOL)isSelectable;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
