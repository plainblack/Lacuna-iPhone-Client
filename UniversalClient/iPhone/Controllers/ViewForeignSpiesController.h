//
//  ViewForeignSpies.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Security;


@interface ViewForeignSpiesController : LETableViewControllerGrouped {
	Security *securityBuilding;
	NSDate *foreignSpiesLastUpdated;
}


@property (nonatomic, retain) Security *securityBuilding;
@property (nonatomic, retain) NSDate *foreignSpiesLastUpdated;


+ (ViewForeignSpiesController *) create;


@end
