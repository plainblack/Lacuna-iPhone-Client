//
//  ViewPrisonersController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "Prisoner.h"


@class Security;


@interface ViewPrisonersController : LETableViewControllerGrouped {
	Security *securityBuilding;
	NSDate *prisonersLastUpdated;
	Prisoner *selectedPrisoner;
}


@property (nonatomic, retain) Security *securityBuilding;
@property (nonatomic, retain) NSDate *prisonersLastUpdated;
@property (nonatomic, retain) Prisoner *selectedPrisoner;


+ (ViewPrisonersController *) create;


@end
