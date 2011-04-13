//
//  ProposeExpelMemberViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectAllianceMemberViewController.h"


@class Parliament;
@class LETableViewCellLabeledTextView;


@interface ProposeExpelMemberViewController : LETableViewControllerGrouped <SelectAllianceMemberViewControllerDelegate> {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *selectedEmpire;
@property (nonatomic, retain) LETableViewCellLabeledTextView *messageCell;


- (IBAction)propose;


+ (ProposeExpelMemberViewController *) create;


@end
