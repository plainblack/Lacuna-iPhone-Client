//
//  SelectTradeableShipController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;
@class Ship;


@protocol SelectTradeableShipControllerDelegate

- (void)shipSelected:(Ship *)ship;

@end


@interface SelectTradeableShipController : LETableViewControllerGrouped {
	BaseTradeBuilding *baseTradeBuilding;
	id<SelectTradeableShipControllerDelegate> delegate;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) id<SelectTradeableShipControllerDelegate> delegate;


+ (SelectTradeableShipController *) create;


@end
