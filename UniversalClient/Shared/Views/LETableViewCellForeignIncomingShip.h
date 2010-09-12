//
//  LETableViewCellForeignIncomingShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/12/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Ship;


@interface LETableViewCellForeignIncomingShip : UITableViewCell {
	UILabel *dateArrivesLabel;
	UILabel *fromNameLabel;
	UILabel *fromEmpireLabel;
}


@property (nonatomic, retain) IBOutlet UILabel *dateArrivesLabel;
@property (nonatomic, retain) IBOutlet UILabel *fromNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *fromEmpireLabel;


- (void)setShip:(Ship *)ship;

+ (LETableViewCellForeignIncomingShip *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
