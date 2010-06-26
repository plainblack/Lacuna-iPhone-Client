//
//  ViewBuildingController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellProgress.h"


@interface ViewBuildingController : LETableViewControllerGrouped <LETableViewCellProgressDelegate, UIActionSheetDelegate> {
	NSString *buildingId;
	NSDictionary *buildingData;
	NSDictionary *resultData;
	NSString *urlPart;
	NSInteger totalBuildTime;
	NSInteger remainingBuildTime;
	NSArray *sections;
	NSMutableDictionary *buildingsByLoc;
	NSMutableDictionary *buttonsByLoc;
	NSNumber *x;
	NSNumber *y;
	NSInteger subsidyBuildQueueCost;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSDictionary *buildingData;
@property(nonatomic, retain) NSDictionary *resultData;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) NSArray *sections;
@property(nonatomic, retain) NSMutableDictionary *buildingsByLoc;
@property(nonatomic, retain) NSMutableDictionary *buttonsByLoc;
@property(nonatomic, retain) NSNumber *x;
@property(nonatomic, retain) NSNumber *y;


+ (ViewBuildingController *)create;


@end
