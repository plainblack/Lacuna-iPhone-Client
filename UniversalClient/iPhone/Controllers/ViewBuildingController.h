//
//  ViewBuildingController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface ViewBuildingController : LETableViewControllerGrouped <UIActionSheetDelegate> {
	NSString *buildingId;
	NSString *urlPart;
	NSMutableDictionary *buildingsByLoc;
	NSMutableDictionary *buttonsByLoc;
	UITableView *selectedTableView;
	NSIndexPath *selectedIndexPath;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) NSMutableDictionary *buildingsByLoc;
@property(nonatomic, retain) NSMutableDictionary *buttonsByLoc;
@property(nonatomic, retain) UITableView *selectedTableView;
@property(nonatomic, retain) NSIndexPath *selectedIndexPath;


+ (ViewBuildingController *)create;


@end
