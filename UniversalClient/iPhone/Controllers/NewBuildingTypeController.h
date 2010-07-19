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
	NSNumber *x;
	NSNumber *y;
	NSMutableDictionary *buttonsByLoc;
}


@property (nonatomic, retain) NSNumber *x;
@property (nonatomic, retain) NSNumber *y;
@property (nonatomic, retain) NSMutableDictionary *buttonsByLoc;


+ (NewBuildingTypeController *)create;


@end
