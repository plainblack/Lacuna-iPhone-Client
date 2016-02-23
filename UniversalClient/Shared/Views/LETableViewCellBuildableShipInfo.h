//
//  LETableViewCellBuildableShipInfo.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BuildableShip;


@interface LETableViewCellBuildableShipInfo : UITableViewCell {
}


@property(nonatomic, retain) IBOutlet UILabel *typeLabel;
@property(nonatomic, retain) IBOutlet UILabel *holdSizeLabel;
@property(nonatomic, retain) IBOutlet UILabel *berthLevelLabel;
@property(nonatomic, retain) IBOutlet UILabel *speedLabel;
@property(nonatomic, retain) IBOutlet UILabel *stealthLabel;
@property(nonatomic, retain) IBOutlet UILabel *combatLabel;
@property(nonatomic, retain) IBOutlet UILabel *maxOccupantLabel;
@property(nonatomic, retain) IBOutlet UIImageView *shipImageView;


- (void)setBuildableShip:(BuildableShip *)buildableShip;

+ (LETableViewCellBuildableShipInfo *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
