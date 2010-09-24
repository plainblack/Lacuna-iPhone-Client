//
//  LETableViewCellMiningPlatform.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MiningPlatform;


@interface LETableViewCellMiningPlatform : UITableViewCell {
	UILabel *asteroidNameLabel;
	UILabel *asteroidLocationLabel;
	UILabel *shippingLabel;
	UIImageView *asteroidImageView;
}


@property(nonatomic, retain) IBOutlet UILabel *asteroidNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *asteroidLocationLabel;
@property(nonatomic, retain) IBOutlet UILabel *shippingLabel;
@property(nonatomic, retain) IBOutlet UIImageView *asteroidImageView;


- (void)setMiningPlatform:(MiningPlatform *)miningPlatform;

+ (LETableViewCellMiningPlatform *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
