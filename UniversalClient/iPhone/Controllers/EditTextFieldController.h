//
//  EditTextFieldController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@protocol EditTextFieldControllerDelegate

- (BOOL)newTextEntryValue:(NSString *)value forTextName:(NSString *)textName;

@end


@class LETableViewCellTextEntry;


@interface EditTextFieldController : LETableViewControllerGrouped <UITextFieldDelegate> {
	LETableViewCellTextEntry *textCell;
	NSString *textName;
	id<EditTextFieldControllerDelegate> delegate;
}


@property(nonatomic, retain) LETableViewCellTextEntry *textCell;
@property(nonatomic, retain) NSString *textName;
@property(nonatomic, assign) id<EditTextFieldControllerDelegate> delegate;


+ (EditTextFieldController *)createForTextName:(NSString *)textName textValue:(NSString *)textValue;


@end
