//
//  ViewAllianceMembersController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Embassy;
@class AllianceStatus;


@interface ViewAllianceMembersController : LETableViewControllerGrouped {
	Embassy *embassy;
	AllianceStatus *watchedAllianceStatus;
	BOOL watched;
}


@property (nonatomic, retain) Embassy *embassy;
@property (nonatomic, retain) AllianceStatus *watchedAllianceStatus;


+ (ViewAllianceMembersController *) create;


@end
