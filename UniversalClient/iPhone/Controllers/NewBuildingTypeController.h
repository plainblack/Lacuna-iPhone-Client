//
//  NewBuildingTypeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@interface NewBuildingTypeController : LETableViewControllerGrouped {
	NSDecimalNumber *x;
	NSDecimalNumber *y;
	NSMutableDictionary *buttonsByLoc;
}


@property (nonatomic, retain) NSDecimalNumber *x;
@property (nonatomic, retain) NSDecimalNumber *y;
@property (nonatomic, retain) NSMutableDictionary *buttonsByLoc;


+ (NewBuildingTypeController *)create;


@end
