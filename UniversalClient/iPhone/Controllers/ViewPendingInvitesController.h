//
//  ViewPendingInvitesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LETableViewControllerGrouped.h"


@class Embassy;


@interface ViewPendingInvitesController : LETableViewControllerGrouped {
	Embassy *embassy;
	BOOL watched;
}


@property (nonatomic, retain) Embassy *embassy;


+ (ViewPendingInvitesController *) create;


@end
