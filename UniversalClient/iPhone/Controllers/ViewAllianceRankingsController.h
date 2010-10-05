//
//  ViewAllianceRankingsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SearchForAllianceInRankingsController.h"


@interface ViewAllianceRankingsController : LETableViewControllerGrouped <SearchForAllianceInRankingsControllerDelegate> {
	UISegmentedControl *pageSegmentedControl;
	NSString *sortBy;
	NSMutableArray *alliances;
	NSDecimalNumber *numAlliances;
	NSInteger pageNumber;
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) NSString *sortBy;
@property (nonatomic, retain) NSMutableArray *alliances;
@property (nonatomic, retain) NSDecimalNumber *numAlliances;


+ (ViewAllianceRankingsController *) create;


@end
