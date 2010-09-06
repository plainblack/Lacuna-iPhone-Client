//
//  NewMailMessageController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class LETableViewCellTextEntry;
@class LETableViewCellTextView;


@interface NewMailMessageController : LETableViewControllerGrouped <UITextFieldDelegate> {
	LETableViewCellTextEntry *toCell;
	LETableViewCellTextEntry *subjectCell;
	LETableViewCellTextView *messageCell;
	NSDictionary *replyToMessage;
}


@property(nonatomic, retain) LETableViewCellTextEntry *toCell;
@property(nonatomic, retain) LETableViewCellTextEntry *subjectCell;
@property(nonatomic, retain) LETableViewCellTextView *messageCell;
@property(nonatomic, retain) NSDictionary *replyToMessage;


- (IBAction)cancelMessage;
- (IBAction)sendMessage;


+ (NewMailMessageController *)create;


@end
