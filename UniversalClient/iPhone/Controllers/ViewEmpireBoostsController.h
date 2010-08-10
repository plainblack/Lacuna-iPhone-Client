//
//  ViewEmpireBoostsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewEmpireBoostsController : LETableViewControllerGrouped <UIActionSheetDelegate> {
	NSMutableDictionary *empireBoosts;
	NSInteger selectedRow;
}


@property(nonatomic, retain) NSMutableDictionary *empireBoosts;


- (UITableViewCell *)setupCellForTableView:(UITableView *)tableView boostEndDate:(NSDate *)boostEndDate name:(NSString *)name;
- (BOOL)isBoosting:(NSDate *)boostEndDate;


+ (ViewEmpireBoostsController *)create;


@end
