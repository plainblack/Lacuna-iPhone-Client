//
//  BuildStashExchangeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/20/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectResourceTypeFromListController.h"


@class Embassy;

typedef enum {
	ADD_TO_UNKNOWN,
	ADD_TO_DEPOSIT,
	ADD_TO_WITHDRAW
} ADD_TO;


@interface BuildStashExchangeController : LETableViewControllerGrouped <SelectResourceTypeFromListControllerDelegate> {
	ADD_TO addTo;
}


@property (nonatomic, retain) Embassy *embassy;
@property (nonatomic, retain) NSMutableDictionary *depositeResources;
@property (nonatomic, retain) NSArray *depositeResourceKeys;
@property (nonatomic, retain) NSMutableDictionary *withdrawResources;
@property (nonatomic, retain) NSArray *withdrawResourceKeys;
@property (nonatomic, retain) NSString *statusMessage;


+ (BuildStashExchangeController *) create;


@end
