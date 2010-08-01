//
//  LETableViewCellShipBuildQueueItem.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ShipBuildQueueItem;


@interface LETableViewCellShipBuildQueueItem : UITableViewCell {
	UILabel *dateCompleteLabel;
	UIImageView *shipImageView;
}


@property(nonatomic, retain) IBOutlet UILabel *dateCompleteLabel;
@property(nonatomic, retain) IBOutlet UIImageView *shipImageView;


- (void)setShipBuildQueueItem:(ShipBuildQueueItem *)shipBuildQueueItem;

+ (LETableViewCellShipBuildQueueItem *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
