//
//  BuildStashDonationController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectResourceTypeFromListController.h"


@class Embassy;


@interface BuildStashDonationController : LETableViewControllerGrouped <SelectResourceTypeFromListControllerDelegate> {
}


@property (nonatomic, retain) Embassy *embassy;
@property (nonatomic, retain) NSMutableDictionary *donatedResources;
@property (nonatomic, retain) NSArray *donatedResourceKeys;


+ (BuildStashDonationController *) create;


@end
