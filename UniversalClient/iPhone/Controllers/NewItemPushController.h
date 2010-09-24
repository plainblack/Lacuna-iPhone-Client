//
//  NewItemPushController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "PickColonyController.h"
#import "SelectGlyphController.h"
#import "SelectPlanController.h"
#import "SelectTradeablePrisonerController.h"
#import "SelectStoredResourceController.h"
#import "SelectTradeableShipController.h"


@class BaseTradeBuilding;
@class ItemPush;


@interface NewItemPushController : LETableViewControllerGrouped <UIActionSheetDelegate, PickColonyDelegate, SelectGlyphControllerDelegate, SelectPlanControllerDelegate, SelectTradeablePrisonerControllerDelegate, SelectStoredResourceControllerDelegate, SelectTradeableShipControllerDelegate> {
	BaseTradeBuilding *baseTradeBuilding;
	ItemPush *itemPush;
	PickColonyController *pickColonyController;
	SelectGlyphController *selectGlyphController;
	SelectPlanController *selectPlanController;
	SelectTradeablePrisonerController *selectTradeablePrisonerController;
	SelectStoredResourceController *selectStoredResourceController;
	SelectTradeableShipController *selectTradeableShipController;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) ItemPush *itemPush;


- (IBAction)send;


+ (NewItemPushController *) create;


@end
