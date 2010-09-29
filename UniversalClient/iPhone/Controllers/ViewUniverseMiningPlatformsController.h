//
//  ViewUniverseMiningPlatformsController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class BaseMapItem;


@interface ViewUniverseMiningPlatformsController : LETableViewControllerGrouped {
	NSMutableArray *miningPlatforms;
	BaseMapItem *mapItem;
}


@property (nonatomic, retain) NSMutableArray *miningPlatforms;
@property (nonatomic, retain) BaseMapItem *mapItem;

+ (ViewUniverseMiningPlatformsController *)create;


@end
