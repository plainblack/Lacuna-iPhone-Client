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
@class Spy;


@interface ViewSpiesController : LETableViewControllerGrouped <UIActionSheetDelegate> {
	Intelligence *intelligenceBuilding;
	NSDate *spiesLastUpdated;
	Spy *selectedSpy;
}


@property (nonatomic, retain) Intelligence *intelligenceBuilding;
@property (nonatomic, retain) NSDate *spiesLastUpdated;
@property (nonatomic, retain) Spy *selectedSpy;


+ (ViewSpiesController *) create;


@end
