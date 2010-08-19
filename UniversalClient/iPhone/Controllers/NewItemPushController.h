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


@class BaseTradeBuilding;
@class ItemPush;
@class PickColonyController;


@interface NewItemPushController : LETableViewControllerGrouped <PickColonyDelegate> {
	BaseTradeBuilding *baseTradeBuilding;
	ItemPush *itemPush;
	PickColonyController *pickColonyController;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) ItemPush *itemPush;


+ (NewItemPushController *) create;


@end
