//
//  ViewSpiesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Intelligence;


@interface ViewSpiesController : LETableViewControllerGrouped {
	Intelligence *intelligenceBuilding;
	NSDate *spiesLastUpdated;
}


@property (nonatomic, retain) Intelligence *intelligenceBuilding;
@property (nonatomic, retain) NSDate *spiesLastUpdated;


+ (ViewSpiesController *) create;


@end
