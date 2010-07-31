//
//  LETableViewCellTravellingShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TravellingShip;


@interface LETableViewCellTravellingShip : UITableViewCell {
	UILabel *dateArrivesLabel;
	UILabel *fromLabel;
	UILabel *toLabel;
	UIImageView *shipImageView;
}


@property(nonatomic, retain) IBOutlet UILabel *dateArrivesLabel;
@property(nonatomic, retain) IBOutlet UILabel *fromLabel;
@property(nonatomic, retain) IBOutlet UILabel *toLabel;
@property(nonatomic, retain) IBOutlet UIImageView *shipImageView;


- (void)setTravellingShip:(TravellingShip *)travellingShip;

+ (LETableViewCellTravellingShip *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
