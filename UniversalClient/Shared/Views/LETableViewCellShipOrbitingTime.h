//
//  LETableViewCellShipOrbitingTime.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/24/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Ship;


@interface LETableViewCellShipOrbitingTime : UITableViewCell {
}


@property (nonatomic, retain) IBOutlet UILabel *dateStartedLabel;
@property (nonatomic, retain) IBOutlet UILabel *fromNameLabel;


- (void)setShip:(Ship *)ship;

+ (LETableViewCellShipOrbitingTime *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
