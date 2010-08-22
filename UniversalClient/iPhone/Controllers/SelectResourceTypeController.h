//
//  SelectResourceTypeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;


@protocol SelectResourceTypeControllerDelegate

- (void)resourceTypeSelected:(NSString *)resourceType;

@end


@interface SelectResourceTypeController : LETableViewControllerGrouped {
	BaseTradeBuilding *baseTradeBuilding;
	id<SelectResourceTypeControllerDelegate> delegate;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, assign) id<SelectResourceTypeControllerDelegate> delegate;


+ (SelectResourceTypeController *) create;


@end
