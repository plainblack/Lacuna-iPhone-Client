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
#import "LETableViewCellAffinitySelector.h"
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
	LETableViewCellAffinitySelector *manufacturingCell;
	LETableViewCellAffinitySelector *deceptionCell;
	LETableViewCellAffinitySelector *researchCell;
	LETableViewCellAffinitySelector *managementCell;
	LETableViewCellAffinitySelector *farmingCell;
	LETableViewCellAffinitySelector *miningCell;
	LETableViewCellAffinitySelector *scienceCell;
	LETableViewCellAffinitySelector *environmentalCell;
	LETableViewCellAffinitySelector *politicalCell;
	LETableViewCellAffinitySelector *tradeCell;
	LETableViewCellAffinitySelector *growthCell;
	
}


@property(nonatomic, retain) NSString *empireId;
@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) LETableViewCellTextEntry *speciesNameCell;
@property(nonatomic, retain) LETableViewCellLabeledTextView *speciesDescriptionCell;
@property(nonatomic, retain) NSArray *orbitCells;
@property(nonatomic, retain) LETableViewCellAffinitySelector *manufacturingCell;
@property(nonatomic, retain) LETableViewCellAffinitySelector *deceptionCell;
@property(nonatomic, retain) LETableViewCellAffinitySelector *researchCell;
@property(nonatomic, retain) LETableViewCellAffinitySelector *managementCell;
@property(nonatomic, retain) LETableViewCellAffinitySelector *farmingCell;
@property(nonatomic, retain) LETableViewCellAffinitySelector *miningCell;
@property(nonatomic, retain) LETableViewCellAffinitySelector *scienceCell;
@property(nonatomic, retain) LETableViewCellAffinitySelector *environmentalCell;
@property(nonatomic, retain) LETableViewCellAffinitySelector *politicalCell;
@property(nonatomic, retain) LETableViewCellAffinitySelector *tradeCell;
@property(nonatomic, retain) LETableViewCellAffinitySelector *growthCell;


- (IBAction)cancel;
- (IBAction)createSpecies;


+ (NewSpeciesController *) create;


@end
