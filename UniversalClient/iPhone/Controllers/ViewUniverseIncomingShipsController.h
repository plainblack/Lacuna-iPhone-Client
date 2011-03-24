//
//  ViewUniverseIncomingShipsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseMapItem;


@interface ViewUniverseIncomingShipsController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) NSMutableArray *incomingShips;
@property (nonatomic, retain) BaseMapItem *mapItem;


+ (ViewUniverseIncomingShipsController *)create;


@end
