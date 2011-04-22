//
//  ProposeForeignAidViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/14/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectEmpireController.h"


@class Parliament;
@class LETableViewCellNumberEntry;


@interface ProposeForeignAidViewController : LETableViewControllerGrouped <SelectEmpireControllerDelegate> {
}


@property (nonatomic, retain) NSDictionary *selectedEmpire;
@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) LETableViewCellNumberEntry *amountCell;


- (void)propose;


+ (ProposeForeignAidViewController *)create;


@end
