//
//  WithdrawAllianceInviteController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"

@class Embassy;
@class LETableViewCellTextView;
@class PendingAllianceInvite;


@interface WithdrawAllianceInviteController : LETableViewControllerGrouped <UIActionSheetDelegate> {
	Embassy *embassy;
	LETableViewCellTextView *messageCell;
	PendingAllianceInvite *invite;
}


@property (nonatomic, retain) Embassy *embassy;
@property (nonatomic, retain) LETableViewCellTextView *messageCell;
@property (nonatomic, retain) PendingAllianceInvite *invite;


- (IBAction)withdrawInvite;


+ (WithdrawAllianceInviteController *) create;


@end
