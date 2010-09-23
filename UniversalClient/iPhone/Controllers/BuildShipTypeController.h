//
//  BuildShipTypeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Shipyard;


@interface BuildShipTypeController : LETableViewControllerGrouped {
	Shipyard *shipyard;
}


@property (nonatomic, retain) Shipyard *shipyard;


+ (BuildShipTypeController *)create;


@end
