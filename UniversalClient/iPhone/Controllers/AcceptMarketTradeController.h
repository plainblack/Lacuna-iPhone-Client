//
//  AcceptMarketTradeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectTradeShipController.h"


@class BaseTradeBuilding;
@class MarketTrade;
@class LETableViewCellTextEntry;


@interface AcceptMarketTradeController : LETableViewControllerGrouped <UITextFieldDelegate, SelectTradeShipControllerDelegate> {
	SelectTradeShipController *selectTradeShipController;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) MarketTrade *trade;
@property (nonatomic, retain) LETableViewCellTextEntry *answerCell;
@property (nonatomic, retain) NSMutableArray *sections;


- (IBAction)acceptTrade;


+ (AcceptMarketTradeController *) create;


@end
