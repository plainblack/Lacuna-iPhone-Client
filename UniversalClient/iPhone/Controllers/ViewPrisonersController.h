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
#import "SpySecurity.h"


@interface ViewPrisonersController : LETableViewControllerGrouped <UIActionSheetDelegate> {
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) NSObject<SpySecurity> *spySecurityBuilding;
@property (nonatomic, retain) NSDate *prisonersLastUpdated;
@property (nonatomic, retain) Prisoner *selectedPrisoner;


+ (ViewPrisonersController *) create;


@end
