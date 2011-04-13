//
//  ProposeRenameUninhabitedViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectStarInJurisdictionViewController.h"
#import "LETableViewCellTextEntry.h"


@class Parliament;


@interface ProposeRenameUninhabitedViewController : LETableViewControllerGrouped <SelectStarInJurisdictionViewControllerDelegate, UITextFieldDelegate> {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *selectedUninhabited;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;


- (void)propose;


+ (ProposeRenameUninhabitedViewController *)create;


@end
