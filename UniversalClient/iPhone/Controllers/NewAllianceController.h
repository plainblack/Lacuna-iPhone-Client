//
//  NewAllianceController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Embassy;
@class LETableViewCellTextEntry;


@interface NewAllianceController : LETableViewControllerGrouped <UITextFieldDelegate> {
	Embassy *embassy;
	LETableViewCellTextEntry *nameCell;
}


@property (nonatomic, retain) Embassy *embassy;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;


- (IBAction)createAlliance;


+ (NewAllianceController *) create;


@end
