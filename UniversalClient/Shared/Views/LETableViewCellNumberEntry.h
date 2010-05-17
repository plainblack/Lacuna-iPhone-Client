//
//  LETableViewCellNumberEntry.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickNumericValueController.h"


@interface LETableViewCellNumberEntry : UITableViewCell <PickNumericValueControllerDelegate> {
	UILabel *label;
	UIButton *numberButton;
	UIViewController *viewController;
	NSNumber *numericValue;
}


@property(nonatomic, retain) IBOutlet UILabel *label;
@property(nonatomic, retain) IBOutlet UIButton *numberButton;
@property(nonatomic, retain) UIViewController *viewController;


- (void)setNumericValue:(NSNumber *)value;
- (IBAction)editNumericValue;


+ (LETableViewCellNumberEntry *)getCellForTableView:(UITableView *)tableView viewController:(UIViewController *)viewController;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
