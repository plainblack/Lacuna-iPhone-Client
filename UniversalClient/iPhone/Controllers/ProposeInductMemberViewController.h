//
//  ProposeInductMemberViewController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "SelectEmpireController.h"


@class Parliament;
@class LETableViewCellLabeledTextView;


@interface ProposeInductMemberViewController : LETableViewControllerGrouped <SelectEmpireControllerDelegate> {
}


@property (nonatomic, retain) Parliament *parliament;
@property (nonatomic, retain) NSDictionary *selectedEmpire;
@property (nonatomic, retain) LETableViewCellLabeledTextView *messageCell;


- (IBAction)propose;


+ (ProposeInductMemberViewController *) create;


@end
