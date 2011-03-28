//
//  NewSpyTradeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/26/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectTradeableSpyController.h"
#import "SelectTradeShipController.h"
#import "PickNumericValueController.h"


@class BaseTradeBuilding;
@class MarketTrade;


@interface NewSpyTradeController : LETableViewControllerGrouped <UIActionSheetDelegate, SelectTradeableSpyControllerDelegate, PickNumericValueControllerDelegate, SelectTradeShipControllerDelegate> {
	SelectTradeableSpyController *selectTradeableSpyController;
	SelectTradeShipController *selectTradeShipController;
	PickNumericValueController *pickNumericValueController;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) MarketTrade *trade;
@property (nonatomic, retain) NSMutableArray *rows;


- (IBAction)post;


+ (NewSpyTradeController *) create;


@end
