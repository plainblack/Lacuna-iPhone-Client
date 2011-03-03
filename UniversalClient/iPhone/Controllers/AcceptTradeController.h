//
//  AcceptTradeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectTradeShipController.h"


@class BaseTradeBuilding;
@class Trade;


@interface AcceptTradeController : LETableViewControllerGrouped <SelectTradeShipControllerDelegate> {
	SelectTradeShipController *selectTradeShipController;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) Trade *trade;
@property (nonatomic, retain) NSMutableArray *sections;


- (IBAction)acceptTrade;


+ (AcceptTradeController *) create;


@end
