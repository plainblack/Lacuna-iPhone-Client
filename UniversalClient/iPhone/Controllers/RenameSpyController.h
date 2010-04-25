//
//  RenameSpyController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextEntry.h"


@interface RenameSpyController : LETableViewControllerGrouped {
	NSString *buildingId;
	NSString *spyId;
	NSString *urlPart;
	LETableViewCellTextEntry *nameCell;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSString *spyId;
@property(nonatomic, retain) NSString *urlPart;
@property(nonatomic, retain) LETableViewCellTextEntry *nameCell;


+ (RenameSpyController *) create;


@end
