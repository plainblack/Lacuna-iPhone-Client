//
//  SelectTradeShipController.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;
@class Ship;


@protocol SelectTradeShipControllerDelegate

- (void)tradeShipSelected:(Ship *)ship;

@end


@interface SelectTradeShipController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) id<SelectTradeShipControllerDelegate> delegate;
@property (nonatomic, retain) NSString *targetBodyId;


+ (SelectTradeShipController *) create;


@end
