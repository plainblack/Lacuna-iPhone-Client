//
//  ViewMailMessageWebController.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellWebView.h"


@class Mailbox;
@class LETableViewCellWebView;


@interface ViewMailMessageWebController : LETableViewControllerGrouped <UIActionSheetDelegate, LETableViewCellWebViewDelegate> {
	UISegmentedControl *messageSegmentedControl;
	Mailbox *mailbox;
	NSInteger messageIndex;
	BOOL isObserving;
	NSDictionary *attachements;
	BOOL hasAttachements;
	BOOL isArchiving;
	BOOL isResending;
	LETableViewCellWebView *bodyCell;
}


@property(nonatomic, retain) UISegmentedControl *messageSegmentedControl;
@property(nonatomic, retain) Mailbox *mailbox;
@property(nonatomic, assign) NSInteger messageIndex;
@property(nonatomic, retain) LETableViewCellWebView *bodyCell;


- (IBAction)archiveMessage;
- (IBAction)resendMessage;
- (IBAction)replyToMessage;
- (IBAction)forwardMessage;
- (IBAction)newMessage;


+ (ViewMailMessageWebController *)create;


@end
