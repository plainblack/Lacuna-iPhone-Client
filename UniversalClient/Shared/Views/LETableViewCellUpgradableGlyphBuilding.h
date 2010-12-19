//
//  LETableViewCellUpgradableGlyphBuilding.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LETableViewCellUpgradableGlyphBuilding : UITableViewCell {
}


@property(nonatomic, retain) IBOutlet UIImageView *buildingImageView;
@property(nonatomic, retain) IBOutlet UIImageView *buildingBackgroundImageView;
@property(nonatomic, retain) IBOutlet UILabel *buildingLevelLabel;
@property(nonatomic, retain) IBOutlet UILabel *buildingXLabel;
@property(nonatomic, retain) IBOutlet UILabel *buildingYLabel;


- (void)parseData:(NSDictionary *)data;


+ (LETableViewCellUpgradableGlyphBuilding *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
