//
//  NewMailMessageController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextEntry.h"


@interface NewMailMessageController : LETableViewControllerGrouped <UITextFieldDelegate> {
	LETableViewCellTextEntry *toCell;
	LETableViewCellTextEntry *subjectCell;
	UITextView *messageTextView;
	NSDictionary *replyToMessage;
}


@property(nonatomic, retain) LETableViewCellTextEntry *toCell;
@property(nonatomic, retain) LETableViewCellTextEntry *subjectCell;
@property(nonatomic, retain) UITextView *messageTextView;
@property(nonatomic, retain) NSDictionary *replyToMessage;


- (IBAction)cancelMessage;
- (IBAction)sendMessage;


+ (NewMailMessageController *)create;


@end
