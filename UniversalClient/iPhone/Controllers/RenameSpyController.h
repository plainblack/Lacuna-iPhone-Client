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


@class Intelligence;
@class Spy;


@interface RenameSpyController : LETableViewControllerGrouped <UITextFieldDelegate> {
	Intelligence *intelligenceBuilding;
	Spy *spy;
	LETableViewCellTextEntry *nameCell;
}


@property(nonatomic, retain) Intelligence *intelligenceBuilding;
@property(nonatomic, retain) Spy *spy;
@property(nonatomic, retain) LETableViewCellTextEntry *nameCell;


+ (RenameSpyController *) create;


@end
