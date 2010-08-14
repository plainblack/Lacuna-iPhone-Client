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
	NSDecimalNumber *numericValue;
	NSInteger maxValue;
}


@property(nonatomic, retain) IBOutlet UILabel *label;
@property(nonatomic, retain) IBOutlet UIButton *numberButton;
@property(nonatomic, retain) UIViewController *viewController;
@property(nonatomic, retain) NSDecimalNumber *numericValue;


- (IBAction)editNumericValue;


+ (LETableViewCellNumberEntry *)getCellForTableView:(UITableView *)tableView viewController:(UIViewController *)viewController maxValue:(NSInteger)maxValue;
+ (CGFloat)getHeightForTableView:(UITableView *)tableView;


@end
