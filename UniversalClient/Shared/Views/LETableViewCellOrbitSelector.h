//
//  LETableViewCellOrbitSelector.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LESpeciesPointsUpdateDelegate.h"


@interface LETableViewCellOrbitSelector : UITableViewCell {
	UILabel *label;
	UISwitch *selectedSwitch;
	id<LESpeciesPointsUpdateDelegate> pointsDelegate;
}


@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UISwitch *selectedSwitch;
@property(nonatomic, assign) id<LESpeciesPointsUpdateDelegate> pointsDelegate;


- (BOOL)isSelected;


+ (LETableViewCellOrbitSelector *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
