//
//  NewAllianceInvite.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectEmpireController.h"

@class Embassy;
@class LETableViewCellLabeledTextView;


@interface NewAllianceInvite : LETableViewControllerGrouped <SelectEmpireControllerDelegate> {
}


@property (nonatomic, retain) Embassy *embassy;
@property (nonatomic, retain) LETableViewCellLabeledTextView *messageCell;
@property (nonatomic, retain) NSMutableArray *invitees;


- (IBAction)sendInvite;


+ (NewAllianceInvite *) create;


@end
