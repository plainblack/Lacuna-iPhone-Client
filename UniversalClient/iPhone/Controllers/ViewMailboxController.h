//
//  ViewMailboxController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "SelectMailboxController.h"
#import "SelectMailboxFilterController.h"


@class Mailbox;


@interface ViewMailboxController : PullRefreshTableViewController <UIActionSheetDelegate, SelectMailboxControllerDelegate, SelectMailboxFilterControllerDelegate> {
    BOOL observingMailbox;
    BOOL observingLastMessageAt;
    LEMailboxType mailboxType;
    LEMailboxFilterType mailboxFilterType;
}


@property (nonatomic, retain) UISegmentedControl *pageSegmentedControl;
@property (nonatomic, retain) UIBarButtonItem *mailboxFilterBarButtonItem;
@property (nonatomic, retain) NSArray *viewingBarButtonItems;
@property (nonatomic, retain) NSArray *editingBarButtonItems;
@property (nonatomic, retain) UIBarButtonItem *editBarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *archiveOrTrashBarButtonItem;
@property (nonatomic, retain) Mailbox *mailbox;
@property (nonatomic, retain) NSTimer *reloadTimer;
@property (nonatomic, retain) NSDate *lastMessageAt;
@property (nonatomic, retain) NSString *showMessageId; 
@property (nonatomic, retain) NSMutableSet *selectedMessageIds;


- (void)clear;
- (IBAction)newMessage;
- (IBAction)showSelectMailbox;
- (void)loadMessages;
- (void)showMessageById:(NSString *)messageId;
- (IBAction)edit:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)trashSelected:(id)sender;
- (IBAction)archiveSelected:(id)sender;
- (void)updateSelectionCount;
- (void)archiveOrTrash;
- (void)setMailboxFilterName;


@end
