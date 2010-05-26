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


@interface RenameBodyController : LETableViewControllerGrouped {
	NSString *bodyId;
	LETableViewCellTextEntry *nameCell;
}


@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) LETableViewCellTextEntry *nameCell;


+ (RenameBodyController *) create;


@end
