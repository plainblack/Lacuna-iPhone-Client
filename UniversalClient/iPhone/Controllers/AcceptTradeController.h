//
//  AcceptTradeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;
@class Trade;
@class LETableViewCellTextEntry;


@interface AcceptTradeController : LETableViewControllerGrouped <UITextFieldDelegate> {
	BaseTradeBuilding *baseTradeBuilding;
	Trade *trade;
	LETableViewCellTextEntry *answerCell;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) Trade *trade;
@property (nonatomic, retain) LETableViewCellTextEntry *answerCell;


- (IBAction)acceptTrade;


+ (AcceptTradeController *) create;


@end
