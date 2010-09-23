//
//  LETableViewCellOribtSelector.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LESpeciesPointsUpdateDelegate.h"
#import "PickNumericValueController.h"


@interface LETableViewCellOrbitSelectorV2 : UITableViewCell <UIAlertViewDelegate, PickNumericValueControllerDelegate> {
	IBOutlet UILabel *nameLabel;
	UIButton *numberButton;
	UIViewController *viewController;
	NSDecimalNumber *numericValue;
	id<LESpeciesPointsUpdateDelegate> pointsDelegate;
}


@property (nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) IBOutlet UIButton *numberButton;
@property(nonatomic, retain) UIViewController *viewController;
@property(nonatomic, retain) NSDecimalNumber *numericValue;
@property (nonatomic, assign) id<LESpeciesPointsUpdateDelegate> pointsDelegate;


- (IBAction)editNumericValue;
- (NSDecimalNumber *)rating;
- (void)setRating:(NSInteger)aRating;


+ (LETableViewCellOrbitSelectorV2 *)getCellForTableView:(UITableView *)tableView;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
