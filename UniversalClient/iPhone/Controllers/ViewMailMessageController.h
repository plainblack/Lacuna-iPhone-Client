//
//  ViewMailMessageController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Mailbox;


@interface ViewMailMessageController : UITableViewController <UIActionSheetDelegate> {
	UISegmentedControl *messageSegmentedControl;
	Mailbox *mailbox;
	NSInteger messageIndex;
	BOOL isObserving;
}


@property(nonatomic, retain) UISegmentedControl *messageSegmentedControl;
@property(nonatomic, retain) Mailbox *mailbox;
@property(nonatomic) NSInteger messageIndex;


- (IBAction)archiveMessage;
- (IBAction)replyToMessage;


@end
