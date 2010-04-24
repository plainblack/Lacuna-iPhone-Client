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


@interface ViewBuildingController : LETableViewControllerGrouped <LETableViewCellProgressDelegate> {
	NSString *buildingId;
	NSDictionary *buildingData;
	NSString *urlPart;
	NSInteger totalBuildTime;
	NSInteger remainingBuildTime;
	NSArray *sections;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSDictionary *buildingData;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) NSArray *sections;


+ (ViewBuildingController *)create;


@end
