//
//  NewOneForOneTradeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectStoredResourceController.h"
#import "SelectResourceTypeController.h"


@class BaseTradeBuilding;
@class OneForOneTrade;


@interface NewOneForOneTradeController : LETableViewControllerGrouped <UIActionSheetDelegate, SelectStoredResourceControllerDelegate, SelectResourceTypeControllerDelegate> {
	BaseTradeBuilding *baseTradeBuilding;
	OneForOneTrade *oneForOneTrade;
	SelectStoredResourceController *selectStoredResourceController;
	SelectResourceTypeController *selectResourceTypeController;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) OneForOneTrade *oneForOneTrade;


- (IBAction)send;


+ (NewOneForOneTradeController *) create;


@end
