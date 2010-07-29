//
//  RenameShipController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextEntry.h"


@class SpacePort;
@class Ship;


@interface RenameShipController : LETableViewControllerGrouped {
	SpacePort *spacePort;
	Ship *ship;
	LETableViewCellTextEntry *nameCell;
}


@property (nonatomic, retain) SpacePort *spacePort;
@property (nonatomic, retain) Ship *ship;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;


+ (RenameShipController *) create;


@end
