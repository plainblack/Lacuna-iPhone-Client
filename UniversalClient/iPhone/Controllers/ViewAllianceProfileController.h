//
//  ViewAllianceProfileController.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class AlliancePublicProfile;


@interface ViewAllianceProfileController : LETableViewControllerGrouped {
	NSString *allianceId;
	AlliancePublicProfile *profile;
}


@property(nonatomic, retain) NSString *allianceId;
@property(nonatomic, retain) AlliancePublicProfile *profile;


+ (ViewAllianceProfileController *)create;


@end
