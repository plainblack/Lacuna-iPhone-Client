//
//  ViewUniverseItemController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseMapItem;


@interface ViewUniverseItemController : LETableViewControllerGrouped {
	BaseMapItem *mapItem;
	NSMutableArray *sections;
	NSArray *oreKeysSorted;
}


@property (nonatomic, retain) BaseMapItem *mapItem;
@property (nonatomic, retain) NSMutableArray *sections;
@property(nonatomic, retain) NSArray *oreKeysSorted;


+ (ViewUniverseItemController *)create;


@end
