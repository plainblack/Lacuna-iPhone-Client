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
	NSString *urlPart;
	NSMutableDictionary *buildingsByLoc;
	NSMutableDictionary *buttonsByLoc;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) NSMutableDictionary *buildingsByLoc;
@property(nonatomic, retain) NSMutableDictionary *buttonsByLoc;


+ (ViewBuildingController *)create;


@end
