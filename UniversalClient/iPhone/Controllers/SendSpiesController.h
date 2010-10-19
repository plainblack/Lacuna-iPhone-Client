//
//  SendSpiesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LETableViewControllerGrouped.h"
#import "PickColonyController.h"
#import "SelectShipFromListController.h"
#import "SelectSpyFromListController.h"


@class BaseMapItem;
@class Ship;


@interface SendSpiesController : LETableViewControllerGrouped <PickColonyDelegate, SelectShipFromListControllerDelegate, SelectSpyFromListControllerDelegate> {
	PickColonyController *pickColonyController;
}


@property (nonatomic, retain) BaseMapItem *mapItem;
@property (nonatomic, retain) NSString *sendFromBodyId;
@property (nonatomic, retain) NSMutableArray *spyShips;
@property (nonatomic, retain) NSMutableDictionary *shipTravelTimes;
@property (nonatomic, retain) Ship *selectedShip;
@property (nonatomic, retain) NSMutableArray *spies;
@property (nonatomic, retain) NSMutableArray *selectedSpies;


+ (SendSpiesController *)create;


@end
