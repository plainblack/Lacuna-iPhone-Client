//
//  EditSavedEmpireV2.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextEntry.h"
#import "SelectServerController.h"


@interface EditSavedEmpireV2 : LETableViewControllerGrouped <UITextFieldDelegate, SelectServerControllerDelegate> {
	NSString *empireKey; 
	LETableViewCellLabeledText *empireNameCell;
	LETableViewCellTextEntry *passwordCell;
	NSDictionary *selectedServer;
}


@property(nonatomic, retain) NSString *empireKey; 
@property(nonatomic, retain) LETableViewCellLabeledText *empireNameCell;
@property(nonatomic, retain) LETableViewCellTextEntry *passwordCell;
@property(nonatomic, retain) NSDictionary *selectedServer;


+ (EditSavedEmpireV2 *)create;


@end
