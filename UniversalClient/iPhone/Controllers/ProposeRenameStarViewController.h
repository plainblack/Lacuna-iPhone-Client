//
//  ProposeRenameStarViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/12/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectStarInJurisdictionViewController.h"
#import "LETableViewCellTextEntry.h"


@class Parliament;


@interface ProposeRenameStarViewController : LETableViewControllerGrouped <SelectStarInJurisdictionViewControllerDelegate, UITextFieldDelegate> {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *selectedStar;
@property (nonatomic, retain) LETableViewCellTextEntry *nameCell;


- (IBAction)propose;


+ (ProposeRenameStarViewController *)create;


@end
