//
//  SelectResourceTypeFromListController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "PickNumericValueController.h"


@protocol SelectResourceTypeFromListControllerDelegate

- (void)selectedStoredResourceType:(NSString *)type amount:(NSDecimalNumber *)amount;

@end


@interface SelectResourceTypeFromListController : LETableViewControllerGrouped <PickNumericValueControllerDelegate> {
	PickNumericValueController *pickNumericValueController;
}


@property (nonatomic, retain) NSMutableDictionary *storedResourceTypes;
@property (nonatomic, retain) NSMutableArray *storedResourceTypeKeys;
@property (nonatomic, retain) NSString *selectedStoredResourceTypeKey;
@property (nonatomic, assign) id<SelectResourceTypeFromListControllerDelegate> delegate;


+ (SelectResourceTypeFromListController *) create;


@end
