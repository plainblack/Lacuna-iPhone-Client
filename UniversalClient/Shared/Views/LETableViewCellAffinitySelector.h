//
//  LETableViewCellAffinitySelector.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LESpeciesPointsUpdateDelegate.h"


@interface LETableViewCellAffinitySelector : UITableViewCell <UIAlertViewDelegate> {
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *valueLabel;
	IBOutlet UIButton *minusButton;
	IBOutlet UIButton *plusButton;
	NSDecimalNumber *value;
	id<LESpeciesPointsUpdateDelegate> pointsDelegate;
}


@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *valueLabel;
@property (nonatomic, retain) UIButton *minusButton;
@property (nonatomic, retain) UIButton *plusButton;
@property (nonatomic, assign) id<LESpeciesPointsUpdateDelegate> pointsDelegate;
@property (nonatomic, retain) NSDecimalNumber *value;


- (IBAction)decreaseValue;
- (IBAction)increaseValue;
- (NSDecimalNumber *)rating;
- (void)setRating:(NSInteger)aRating;


+ (LETableViewCellAffinitySelector *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
