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
	NSInteger selectedSection;
	NSTimer *timer;
}


@property(nonatomic, retain) NSMutableDictionary *empireBoosts;


//- (BOOL)isBoosting:(NSDate *)boostEndDate;
- (UITableViewCell *)setupExpiresCellForTableView:(UITableView *)tableView secondsRemaining:(NSInteger)secondsRemaining;
- (UITableViewCell *)setupButtonCellForTableView:(UITableView *)tableView secondsRemaining:(NSInteger)secondsRemaining name:(NSString *)name;


+ (ViewEmpireBoostsController *)create;


@end
