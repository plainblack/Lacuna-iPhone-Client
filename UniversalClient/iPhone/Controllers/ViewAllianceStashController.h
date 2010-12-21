//
//  ViewAllianceController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Embassy;


@interface ViewAllianceStashController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) Embassy *embassy;
@property (nonatomic, retain) NSArray *stashKeys;


+ (ViewAllianceStashController *)create;



@end
