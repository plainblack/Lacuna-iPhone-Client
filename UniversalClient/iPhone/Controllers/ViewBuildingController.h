//
//  ViewBuildingController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Building;


@interface ViewBuildingController : LETableViewControllerGrouped <UIActionSheetDelegate> {
	NSString *buildingId;
	NSString *urlPart;
	UITableView *selectedTableView;
	NSIndexPath *selectedIndexPath;
	Building *watchedBuilding;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) UITableView *selectedTableView;
@property(nonatomic, retain) NSIndexPath *selectedIndexPath;
@property(nonatomic, retain) Building *watchedBuilding;


+ (ViewBuildingController *)create;


@end
