//
//  FetchSpiesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "PickColonyController.h"
#import "SelectShipFromListController.h"
#import "SelectSpyFromListController.h"


@class BaseMapItem;
@class Ship;


@interface FetchSpiesController : LETableViewControllerGrouped <PickColonyDelegate, SelectShipFromListControllerDelegate, SelectSpyFromListControllerDelegate> {
	BaseMapItem *mapItem;
	NSString *fetchToBodyId;
	PickColonyController *pickColonyController;
	NSMutableArray *spyShips;
	Ship *selectedShip;
	NSMutableArray *spies;
	NSMutableArray *selectedSpies;
}


@property (nonatomic, retain) BaseMapItem *mapItem;
@property (nonatomic, retain) NSString *fetchToBodyId;
@property (nonatomic, retain) NSMutableArray *spyShips;
@property (nonatomic, retain) Ship *selectedShip;
@property (nonatomic, retain) NSMutableArray *spies;
@property (nonatomic, retain) NSMutableArray *selectedSpies;


+ (FetchSpiesController *)create;


@end
