//
//  ViewShipsByTypeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 2/23/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class SpacePort;


@interface ViewShipsByTypeController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) SpacePort	*spaceport;


+ (ViewShipsByTypeController *)create;


@end
