//
//  LETableViewCellLabeledParagraph.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellLabeledParagraph : UITableViewCell {
	UILabel *label;
	UITextView *content;
}


@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UITextView *content;


+ (LETableViewCellLabeledParagraph *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView text:(NSString *)text;


@end
