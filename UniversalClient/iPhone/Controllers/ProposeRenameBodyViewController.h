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
#import "SelectBodyForStarInJurisdictionViewController.h"
#import "LETableViewCellTextEntry.h"


@class Parliament;


@interface ProposeRenameBodyViewController : LETableViewControllerGrouped <SelectStarInJurisdictionViewControllerDelegate, SelectBodyForStarInJurisdictionViewControllerDelegate, UITextFieldDelegate> {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *selectedStar;
@property (nonatomic, retain) NSDictionary *selectedBody;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;


- (void)propose;


+ (ProposeRenameBodyViewController *)create;


@end
