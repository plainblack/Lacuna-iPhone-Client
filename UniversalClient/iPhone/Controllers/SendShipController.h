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


@interface SendShipController : LETableViewControllerGrouped <PickColonyDelegate> {
	NSMutableArray *availableShips;
	BaseMapItem *mapItem;
	NSString *sendFromBodyId;
	PickColonyController *pickColonyController;
}


@property (nonatomic, retain) NSMutableArray *availableShips;
@property (nonatomic, retain) BaseMapItem *mapItem;
@property (nonatomic, retain) NSString *sendFromBodyId;


+ (SendShipController *)create;


@end
