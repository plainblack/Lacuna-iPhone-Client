//
//  RenameSpeciesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/7/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellTextView.h"


@class GeneticsLab;


@interface RenameSpeciesController : LETableViewControllerGrouped <UITextFieldDelegate, UIActionSheetDelegate> {
}


@property (nonatomic, retain) GeneticsLab *geneticsLab;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;
@property (nonatomic, retain) LETableViewCellTextView *descriptionCell;
@property (nonatomic, retain) NSMutableDictionary *speciesStats;


+ (RenameSpeciesController *) create;


@end
