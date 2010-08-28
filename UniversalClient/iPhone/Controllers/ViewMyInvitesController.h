//
//  ViewMyInvitesContorller.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Embassy;


@interface ViewMyInvitesController : LETableViewControllerGrouped {
	Embassy *embassy;
}


@property (nonatomic, retain) Embassy *embassy;


+ (ViewMyInvitesController *) create;


@end
