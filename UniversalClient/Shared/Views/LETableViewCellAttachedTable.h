//
//  LETableViewCellAttachedTable.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellAttachedTable : UITableViewCell {
	NSArray *headers;
	NSArray *
}


@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) NSString *link;


- (void)setData:(NSDictionary *)tableAttachmentData;

+ (LETableViewCellAttachedTable *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
