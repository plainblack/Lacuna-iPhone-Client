//
//  ViewUniverseOrbitingShipsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/24/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "PickColonyController.h"


@class BaseMapItem;


@interface ViewUniverseOrbitingShipsController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) NSMutableArray *orbitingShips;
@property (nonatomic, retain) BaseMapItem *mapItem;


+ (ViewUniverseOrbitingShipsController *)create;


@end
