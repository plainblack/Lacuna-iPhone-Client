//
//  BuildStashExchangeController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "PickNumericValueController.h"


@class Embassy;


@interface BuildStashExchangeController : LETableViewControllerGrouped <PickNumericValueControllerDelegate> {
	PickNumericValueController *pickNumericValueController;
}


@property (nonatomic, retain) Embassy *embassy;
@property (nonatomic, retain) NSMutableDictionary *storedResources;
@property (nonatomic, retain) NSMutableArray *storedResourceKeys;
@property (nonatomic, retain) NSMutableDictionary *donatedResources;


+ (BuildStashExchangeController *) create;


@end
