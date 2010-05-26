//
//  NewEmpireController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextEntry.h"
//#import "LEActivityIndicatorView.h"


@interface NewEmpireController : LETableViewControllerGrouped <UITextFieldDelegate> {
//	LEActivityIndicatorView *activityIndicator;
	LETableViewCellTextEntry *nameCell;
	LETableViewCellTextEntry *passwordCell;
	LETableViewCellTextEntry *passwordConfirmationCell;
	UITableViewCell *speciesCell;
	UISegmentedControl *speciesSelector;
	NSString *empireId;
}


//@property(nonatomic, retain) LEActivityIndicatorView *activityIndicator;
@property(nonatomic, retain) LETableViewCellTextEntry *nameCell;
@property(nonatomic, retain) LETableViewCellTextEntry *passwordCell;
@property(nonatomic, retain) LETableViewCellTextEntry *passwordConfirmationCell;
@property(nonatomic, retain) UITableViewCell *speciesCell;
@property(nonatomic, retain) UISegmentedControl *speciesSelector;
@property(nonatomic, retain) NSString *empireId;


- (IBAction)speciesSelected;


+ (NewEmpireController *) create;


@end
