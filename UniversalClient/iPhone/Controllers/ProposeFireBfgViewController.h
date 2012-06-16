//
//  ProposeFireBfgViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectStarInJurisdictionViewController.h"
#import "SelectBodyForStarInJurisdictionViewController.h"


@class Parliament;
@class LETableViewCellLabeledTextView;


@interface ProposeFireBfgViewController : LETableViewControllerGrouped <SelectStarInJurisdictionViewControllerDelegate, SelectBodyForStarInJurisdictionViewControllerDelegate> {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *selectedStar;
@property (nonatomic, retain) NSDictionary *selectedBody;
@property (nonatomic, retain) LETableViewCellLabeledTextView *reasonCell;


- (IBAction)propose;


+ (ProposeFireBfgViewController *)create;


@end
