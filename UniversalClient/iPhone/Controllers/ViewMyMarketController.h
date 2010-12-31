//
//  ViewMyMarketController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;


@interface ViewMyMarketController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) NSDate *myMarketLastUpdated;


+ (ViewMyMarketController *) create;


@end
