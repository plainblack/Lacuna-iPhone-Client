//
//  SelectMailboxController.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/1/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "Mailbox.h"


@protocol SelectMailboxControllerDelegate

- (void)selectedMailbox:(LEMailboxType)mailboxType;

@end


@interface SelectMailboxController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) id<SelectMailboxControllerDelegate> delegate;


+ (SelectMailboxController *)create;


@end
