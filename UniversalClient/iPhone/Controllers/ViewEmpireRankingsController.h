//
//  ViewEmpireRankingsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SearchForEmpireInRankingsController.h"


@interface ViewEmpireRankingsController : LETableViewControllerGrouped <SearchForEmpireInRankingsControllerDelegate> {
	UISegmentedControl *pageSegmentedControl;
	NSString *sortBy;
	NSMutableArray *empires;
	NSDecimalNumber *numEmpires;
	NSInteger pageNumber;
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSMutableArray *empires;
@property (nonatomic, retain) NSDecimalNumber *numEmpires;


+ (ViewEmpireRankingsController *) create;


@end
