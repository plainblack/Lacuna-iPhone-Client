//
//  LETableViewCellBuildingStorage.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ResourceStorage;


@interface LETableViewCellBuildingStorage : UITableViewCell {
	UILabel *energyStorageLabel;
	UILabel *foodStorageLabel;
	UILabel *oreStorageLabel;
	UILabel *wasteStorageLabel;
	UILabel *waterStorageLabel;
}

@property(nonatomic, retain) IBOutlet UILabel *energyStorageLabel;
@property(nonatomic, retain) IBOutlet UILabel *foodStorageLabel;
@property(nonatomic, retain) IBOutlet UILabel *oreStorageLabel;
@property(nonatomic, retain) IBOutlet UILabel *wasteStorageLabel;
@property(nonatomic, retain) IBOutlet UILabel *waterStorageLabel;


- (void)setResourceStorage:(ResourceStorage *)resourceStorage;


+ (LETableViewCellBuildingStorage *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
