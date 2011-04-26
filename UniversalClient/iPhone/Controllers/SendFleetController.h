//
//  SendFleetController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "PickColonyController.h"
#import "LETableViewCellNumberEntry.h"


@class BaseMapItem;
@class Ship;

@interface SendFleetController : LETableViewControllerGrouped <PickColonyDelegate, UIActionSheetDelegate> {
	PickColonyController *pickColonyController;
}


@property (nonatomic, retain) IBOutlet LETableViewCellNumberEntry *fleetSpeedCell;
@property (nonatomic, retain) NSMutableArray *availableShips;
@property (nonatomic, retain) NSMutableDictionary *shipTravelTimes;
@property (nonatomic, retain) BaseMapItem *mapItem;
@property (nonatomic, retain) NSString *sendFromBodyId;
@property (nonatomic, retain) Ship *selectedShip;
@property (nonatomic, retain) NSMutableArray *fleetShips;


+ (SendFleetController *)create;


@end
