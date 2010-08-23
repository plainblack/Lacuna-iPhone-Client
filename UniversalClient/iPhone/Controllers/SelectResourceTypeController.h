//
//  SelectResourceTypeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "PickNumericValueController.h"


@class BaseTradeBuilding;


@protocol SelectResourceTypeControllerDelegate

- (void)resourceTypeSelected:(NSString *)resourceType withQuantity:(NSDecimalNumber *)quantity;

@end


@interface SelectResourceTypeController : LETableViewControllerGrouped  <PickNumericValueControllerDelegate> {
	BaseTradeBuilding *baseTradeBuilding;
	id<SelectResourceTypeControllerDelegate> delegate;
	BOOL includeQuantity;
	PickNumericValueController *pickNumericValueController;
	NSString *selectedResourceType;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) id<SelectResourceTypeControllerDelegate> delegate;
@property (nonatomic, assign) BOOL includeQuantity;
@property (nonatomic, retain) NSString *selectedResourceType;


+ (SelectResourceTypeController *) create;


@end
