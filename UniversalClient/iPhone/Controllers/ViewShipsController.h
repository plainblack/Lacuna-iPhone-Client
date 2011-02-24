//
//  ViewShips.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class SpacePort;
@class Ship;


@interface ViewShipsController : LETableViewControllerGrouped <UIActionSheetDelegate> {
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) SpacePort *spacePort;
@property (nonatomic, retain) Ship *ship;
@property (nonatomic, retain) NSDate *shipsLastUpdated;


+ (ViewShipsController *)create;


@end
