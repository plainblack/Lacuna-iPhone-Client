NSMutableDictionary *selectedStoredResource;
//
//  SelectStoredResource.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseTradeBuilding;


@protocol SelectStoredResourceControllerDelegate

- (void)storedResourceSelected:(NSDictionary *)storedResource;

@end


@interface SelectStoredResourceController : LETableViewControllerGrouped {
	BaseTradeBuilding *baseTradeBuilding;
	NSMutableDictionary *selectedStoredResource;
	id<SelectStoredResourceControllerDelegate> delegate;
}


@property (nonatomic, retain) BaseTradeBuilding *baseTradeBuilding;
@property (nonatomic, retain) 	NSMutableDictionary *selectedStoredResource;
@property (nonatomic, assign) id<SelectStoredResourceControllerDelegate> delegate;


+ (SelectStoredResourceController *) create;


@end
