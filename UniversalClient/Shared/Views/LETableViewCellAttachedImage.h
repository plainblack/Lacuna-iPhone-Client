//
//  LETableViewCellAttachedImage.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellAttachedImage : UITableViewCell {
	UIImageView *imageView;
	UILabel *nameLabel;
	NSString *link;
}


@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) NSString *link;


- (void)setData:(NSDictionary *)imageAttachmentData;

+ (LETableViewCellAttachedImage *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
