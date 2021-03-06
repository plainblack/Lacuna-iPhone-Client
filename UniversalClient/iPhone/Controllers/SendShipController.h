//
//  SendShipController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "PickColonyController.h"


@class BaseMapItem;
@class Ship;


@interface SendShipController : LETableViewControllerGrouped <PickColonyDelegate, UIActionSheetDelegate> {
	PickColonyController *pickColonyController;
}


@property (nonatomic, retain) NSMutableArray *availableShips;
@property (nonatomic, retain) NSMutableDictionary *shipTravelTimes;
@property (nonatomic, retain) BaseMapItem *mapItem;
@property (nonatomic, retain) NSString *sendFromBodyId;
@property (nonatomic, retain) Ship *selectedShip;


+ (SendShipController *)create;


@end
