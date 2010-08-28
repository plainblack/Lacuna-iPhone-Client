//
//  EditTextViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@protocol EditTextViewControllerDelegate

- (BOOL)newTextValue:(NSString *)value forTextName:(NSString *)textName;

@end


@class LETableViewCellTextView;


@interface EditTextViewController : LETableViewControllerGrouped {
	LETableViewCellTextView *textCell;
	NSString *textName;
	id<EditTextViewControllerDelegate> delegate;
}


@property(nonatomic, retain) LETableViewCellTextView *textCell;
@property(nonatomic, retain) NSString *textName;
@property(nonatomic, assign) id<EditTextViewControllerDelegate> delegate;


+ (EditTextViewController *)createForTextName:(NSString *)textName textValue:(NSString *)textValue;


@end
