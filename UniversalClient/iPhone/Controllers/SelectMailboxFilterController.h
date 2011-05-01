//
//  SelectMailboxFilterController.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/1/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "Mailbox.h"


@protocol SelectMailboxFilterControllerDelegate

- (void)selectedMailboxFilter:(LEMailboxFilterType)mailboxFilterType;

@end


@interface SelectMailboxFilterController : LETableViewControllerGrouped {
}


@property (nonatomic, retain) id<SelectMailboxFilterControllerDelegate> delegate;


+ (SelectMailboxFilterController *)create;


@end
