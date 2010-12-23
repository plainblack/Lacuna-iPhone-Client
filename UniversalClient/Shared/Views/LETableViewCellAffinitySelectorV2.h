//
//  LETableViewCellAffinitySelectorV2.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LESpeciesPointsUpdateDelegate.h"
#import "PickNumericValueController.h"


@interface LETableViewCellAffinitySelectorV2 : UITableViewCell <UIAlertViewDelegate, PickNumericValueControllerDelegate> {
}


@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) IBOutlet UIButton *numberButton;
@property(nonatomic, retain) UIViewController *viewController;
@property(nonatomic, retain) NSDecimalNumber *numericValue;
@property(nonatomic, assign) id<LESpeciesPointsUpdateDelegate> pointsDelegate;
@property(nonatomic, retain) NSDecimalNumber *minValue;


- (IBAction)editNumericValue;
- (NSDecimalNumber *)rating;
- (void)setRating:(NSInteger)aRating;


+ (LETableViewCellAffinitySelectorV2 *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
