//
//  LETableViewCellParagraph.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellParagraph : UITableViewCell {
	UITextView *content;
}


@property(nonatomic, retain) UITextView *content;


+ (LETableViewCellParagraph *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView text:(NSString *)text;


@end
