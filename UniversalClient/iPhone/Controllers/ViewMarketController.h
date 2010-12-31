//
//  ViewMarketController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;


@interface ViewMarketController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) NSDate *marketLastUpdated;


+ (ViewMarketController *) create;


@end
