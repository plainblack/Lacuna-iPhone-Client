//
//  RenameEmpireController.h
//  UniversalClient
//
//  Created by Kevin Runde on 11/16/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextEntry.h"


@class Capitol;


@interface RenameEmpireController : LETableViewControllerGrouped <UITextFieldDelegate, UIActionSheetDelegate> {
}


@property (nonatomic, retain) Capitol *capitol;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;


+ (RenameEmpireController *) create;


@end
