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
}


@property (nonatomic, retain) IBOutlet UILabel *dateStartedLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateArrivesLabel;
@property (nonatomic, retain) IBOutlet UILabel *fromNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *toNameLabel;


- (void)setShip:(Ship *)ship;

+ (LETableViewCellTravellingShip *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
