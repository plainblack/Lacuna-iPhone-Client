//
//  LETableViewCellAttachedLink.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellAttachedLink : UITableViewCell {
	UILabel *nameLabel;
	NSString *link;
}


@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) NSString *link;


- (void)setData:(NSDictionary *)linkAttachmentData;

+ (LETableViewCellAttachedLink *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
