//
//  ViewPublicEmpireProfileController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class PublicEmpireProfile;


@interface ViewPublicEmpireProfileController : LETableViewControllerGrouped {
	NSString *empireId;
	PublicEmpireProfile *profile;
}


@property(nonatomic, retain) NSString *empireId;
@property(nonatomic, retain) PublicEmpireProfile *profile;


+ (ViewPublicEmpireProfileController *)create;


@end
