//
//  ViewTravellingShipsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "ShipIntel.h"


@interface ViewTravellingShipsController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) NSObject<ShipIntel> *shipIntel;
@property (nonatomic, retain) NSDate *lastUpdated;


+ (ViewTravellingShipsController *)create;


@end
