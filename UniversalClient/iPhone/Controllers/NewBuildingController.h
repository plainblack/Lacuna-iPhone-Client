//
//  NewBuildingController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LEGetBuildables;


@interface NewBuildingController : LETableViewControllerGrouped {
	UISegmentedControl *listChooser;
	NSString *bodyId;
	NSMutableDictionary *buildingsByLoc;
	NSMutableDictionary *buttonsByLoc;
	NSArray *buildables;
	NSArray *allBuildings;
	NSArray *buildableBuildings;
	NSNumber *x;
	NSNumber *y;
	LEGetBuildables *leGetBuildables;
	NSInteger selectedBuilding;
}


@property(nonatomic, retain) UISegmentedControl *listChooser;
@property(nonatomic, retain) NSMutableDictionary *buildingsByLoc;
@property(nonatomic, retain) NSMutableDictionary *buttonsByLoc;
@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) NSArray *buildables;
@property(nonatomic, retain) NSArray *allBuildings;
@property(nonatomic, retain) NSArray *buildableBuildings;
@property(nonatomic, retain) NSNumber *x;
@property(nonatomic, retain) NSNumber *y;
@property(nonatomic, retain) LEGetBuildables *leGetBuildables;


- (IBAction)switchList;


+ (NewBuildingController *)create;


@end
