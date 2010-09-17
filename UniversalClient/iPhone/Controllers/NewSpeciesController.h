//
//  NewSpeciesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 4/11/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellAffinitySelectorV2.h"
#import "LESpeciesPointsUpdateDelegate.h"
#import "LETableViewCellLabeledTextView.h"


@interface NewSpeciesController : LETableViewControllerGrouped <UITextFieldDelegate, LESpeciesPointsUpdateDelegate> {
	NSString *empireId;
	NSString *username;
	NSString *password;
	NSInteger points;
	LETableViewCellTextEntry *speciesNameCell;
	LETableViewCellLabeledTextView *speciesDescriptionCell;
	NSArray *orbitCells;
	LETableViewCellAffinitySelectorV2 *manufacturingCell;
	LETableViewCellAffinitySelectorV2 *deceptionCell;
	LETableViewCellAffinitySelectorV2 *researchCell;
	LETableViewCellAffinitySelectorV2 *managementCell;
	LETableViewCellAffinitySelectorV2 *farmingCell;
	LETableViewCellAffinitySelectorV2 *miningCell;
	LETableViewCellAffinitySelectorV2 *scienceCell;
	LETableViewCellAffinitySelectorV2 *environmentalCell;
	LETableViewCellAffinitySelectorV2 *politicalCell;
	LETableViewCellAffinitySelectorV2 *tradeCell;
	LETableViewCellAffinitySelectorV2 *growthCell;
	
}


@property(nonatomic, retain) NSString *empireId;
@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) LETableViewCellTextEntry *speciesNameCell;
@property(nonatomic, retain) LETableViewCellLabeledTextView *speciesDescriptionCell;
@property(nonatomic, retain) NSArray *orbitCells;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *manufacturingCell;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *deceptionCell;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *researchCell;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *managementCell;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *farmingCell;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *miningCell;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *scienceCell;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *environmentalCell;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *politicalCell;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *tradeCell;
@property(nonatomic, retain) LETableViewCellAffinitySelectorV2 *growthCell;


- (IBAction)cancel;
- (IBAction)createSpecies;


+ (NewSpeciesController *) create;


@end
