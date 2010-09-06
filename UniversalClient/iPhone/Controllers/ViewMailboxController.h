//
//  ViewMailboxController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Mailbox;


@interface ViewMailboxController : UITableViewController <UIActionSheetDelegate> {
	UISegmentedControl *pageSegmentedControl;
	UISegmentedControl *mailboxSegmentedControl;
	NSArray *inboxBarButtonItems;
	NSArray *otherMailboxBarButtonItems;
	Mailbox *mailbox;
	NSTimer *reloadTimer;
	NSDate *lastMessageAt;
	BOOL observingMailbox;
}


@property(nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property(nonatomic, retain) UISegmentedControl *mailboxSegmentedControl;
@property(nonatomic, retain) NSArray *inboxBarButtonItems;
@property(nonatomic, retain) NSArray *otherMailboxBarButtonItems;
@property(nonatomic, retain) Mailbox *mailbox;
@property(nonatomic, retain) NSTimer *reloadTimer;
@property(nonatomic, retain) NSDate *lastMessageAt;


- (void)clear;
- (IBAction)newMessage;
- (IBAction)switchMailBox;
- (void)loadMessages;


@end
