//
//  StoreResourcesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/15/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectResourceTypeFromListController.h"


@class DistributionCenter;


@interface ReserveResourcesController : LETableViewControllerGrouped <SelectResourceTypeFromListControllerDelegate> {
	SelectResourceTypeFromListController *selectResourceTypeFromListController;
}


@property (nonatomic, retain) DistributionCenter *distributionCenter;
@property (nonatomic, retain) NSMutableArray *reserveRequest;
@property (nonatomic, retain) NSMutableDictionary *storedResources;
@property (nonatomic, retain) NSDecimalNumber *cargoSpaceUsedPer;


- (IBAction)reserve;


+ (ReserveResourcesController *) create;


@end
