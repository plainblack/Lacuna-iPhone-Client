//
//  ViewForeignSpies.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SpySecurity.h"


@interface ViewForeignSpiesController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) NSObject<SpySecurity> *spySecurityBuilding;
@property (nonatomic, retain) NSDate *foreignSpiesLastUpdated;


+ (ViewForeignSpiesController *) create;


@end
