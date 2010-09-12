//
//  LETableViewCellTravellingShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Ship;


@interface LETableViewCellTravellingShip : UITableViewCell {
	UILabel *dateArrivesLabel;
	UILabel *typeLabel;
	UILabel *fromLabel;
	UILabel *toLabel;
	UIImageView *shipImageView;
}


@property (nonatomic, retain) IBOutlet UILabel *dateArrivesLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *fromLabel;
@property (nonatomic, retain) IBOutlet UILabel *toLabel;
@property (nonatomic, retain) IBOutlet UIImageView *shipImageView;


- (void)setTravellingShip:(Ship *)ship;

+ (LETableViewCellTravellingShip *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
