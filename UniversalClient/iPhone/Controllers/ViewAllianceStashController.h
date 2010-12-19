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
@property (nonatomic, retain) NSMutableDictionary *stash;
@property (nonatomic, retain) NSArray *stashKeys;
@property (nonatomic, retain) NSMutableDictionary *storedResources;
@property (nonatomic, retain) NSDecimalNumber *maxExchangeSize;
@property (nonatomic, retain) NSDecimalNumber *exchangesRemainingToday;


+ (ViewAllianceStashController *)create;



@end
