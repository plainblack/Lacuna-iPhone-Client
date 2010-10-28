//
//  NewTradeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectGlyphController.h"
#import "SelectPlanController.h"
#import "SelectTradeablePrisonerController.h"
#import "SelectResourceTypeController.h"
#import "SelectTradeableShipController.h"
#import "SelectStoredResourceController.h"
#import "SelectTradeShipController.h"


@class BaseTradeBuilding;
@class Trade;


@interface NewTradeController : LETableViewControllerGrouped <UIActionSheetDelegate, SelectGlyphControllerDelegate, SelectPlanControllerDelegate, SelectTradeablePrisonerControllerDelegate, SelectResourceTypeControllerDelegate, SelectTradeableShipControllerDelegate, SelectStoredResourceControllerDelegate, SelectTradeShipControllerDelegate> {
	SelectGlyphController *selectGlyphController;
	SelectPlanController *selectPlanController;
	SelectTradeablePrisonerController *selectTradeablePrisonerController;
	SelectResourceTypeController *selectResourceTypeController;
	SelectTradeableShipController *selectTradeableShipController;
	SelectStoredResourceController *selectStoredResourceController;
	SelectTradeShipController *selectTradeShipController;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) Trade *trade;
@property (nonatomic, retain) NSMutableArray *sections;


- (IBAction)post;


+ (NewTradeController *) create;


@end
