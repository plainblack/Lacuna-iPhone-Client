//
//  ProposeTransferStationOwnership.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/10/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectAllianceMemberViewController.h"


@class Parliament;


@interface ProposeTransferStationOwnership : LETableViewControllerGrouped <SelectAllianceMemberViewControllerDelegate> {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *selectedEmpire;


- (IBAction)propose;


+ (ProposeTransferStationOwnership *)create;


@end
