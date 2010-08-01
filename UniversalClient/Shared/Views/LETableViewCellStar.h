//
//  LETableViewCellStar.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Star;


@interface LETableViewCellStar : UITableViewCell {
	UILabel *nameLabel;
	UILabel *locationLabel;
	UIImageView *starImageView;
}


@property(nonatomic, retain) IBOutlet UILabel *nameLabel;
@property(nonatomic, retain) IBOutlet UILabel *locationLabel;
@property(nonatomic, retain) IBOutlet UIImageView *starImageView;


- (void)setStar:(Star *)star;

+ (LETableViewCellStar *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
