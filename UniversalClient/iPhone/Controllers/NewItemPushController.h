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
#import "SelectStoredResourceController.h"


@class BaseTradeBuilding;
@class ItemPush;


@interface NewItemPushController : LETableViewControllerGrouped <PickColonyDelegate, SelectGlyphControllerDelegate, SelectPlanControllerDelegate, SelectStoredResourceControllerDelegate> {
	BaseTradeBuilding *baseTradeBuilding;
	ItemPush *itemPush;
	PickColonyController *pickColonyController;
	SelectGlyphController *selectGlyphController;
	SelectPlanController *selectPlanController;
	SelectStoredResourceController *selectStoredResourceController;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) ItemPush *itemPush;


+ (NewItemPushController *) create;


@end
