//
//  RenameBodyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextEntry.h"


@class Body;


@interface RenameBodyController : LETableViewControllerGrouped <UITextFieldDelegate> {
	Body *body;
	LETableViewCellTextEntry *nameCell;
}


@property(nonatomic, retain) Body *body;
@property(nonatomic, retain) LETableViewCellTextEntry *nameCell;


+ (RenameBodyController *) create;


@end
