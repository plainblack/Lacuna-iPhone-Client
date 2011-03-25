//
//  NewTradeForMarketController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectGlyphController.h"
#import "SelectPlanController.h"
#import "SelectTradeablePrisonerController.h"
#import "SelectTradeableSpyController.h"
#import "SelectTradeableShipController.h"
#import "SelectStoredResourceController.h"
#import "SelectTradeShipController.h"
#import "PickNumericValueController.h"



@class BaseTradeBuilding;
@class MarketTrade;


@interface NewTradeForMarketController : LETableViewControllerGrouped <UIActionSheetDelegate, SelectGlyphControllerDelegate, SelectPlanControllerDelegate, SelectTradeablePrisonerControllerDelegate, SelectTradeableSpyControllerDelegate, SelectTradeableShipControllerDelegate, SelectStoredResourceControllerDelegate, PickNumericValueControllerDelegate, SelectTradeShipControllerDelegate> {
	SelectGlyphController *selectGlyphController;
	SelectPlanController *selectPlanController;
	SelectTradeablePrisonerController *selectTradeablePrisonerController;
	SelectTradeableSpyController *selectTradeableSpyController;
	SelectTradeableShipController *selectTradeableShipController;
	SelectStoredResourceController *selectStoredResourceController;
	SelectTradeShipController *selectTradeShipController;
	PickNumericValueController *pickNumericValueController;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) MarketTrade *trade;
@property (nonatomic, retain) NSMutableArray *sections;


- (IBAction)post;


+ (NewTradeForMarketController *) create;


@end
