//
//  DisolveAllianceController.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"


@class Embassy;
@class LETableViewCellLabeledParagraph;
@class LETableViewCellButton;


@interface DisolveAllianceController : LETableViewControllerGrouped <UIActionSheetDelegate> {
	Embassy *embassy;
	LETableViewCellLabeledParagraph *warningCell;
	LETableViewCellButton *disolveButtonCell;
}


@property (nonatomic, retain) Embassy *embassy;
@property (nonatomic, retain) LETableViewCellLabeledParagraph *warningCell;
@property (nonatomic, retain) LETableViewCellButton *disolveButtonCell;


- (IBAction)disolveAlliance;


+ (DisolveAllianceController *) create;


@end
