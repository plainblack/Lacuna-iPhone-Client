//
//  EditSpeciesController.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/20/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LETableViewControllerGrouped.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellAffinitySelectorV2.h"
#import "LETableViewCellOrbitSelectorV2.h"
#import "LESpeciesPointsUpdateDelegate.h"
#import "LETableViewCellLabeledTextView.h"


@interface EditSpeciesController : LETableViewControllerGrouped <UITextFieldDelegate, LESpeciesPointsUpdateDelegate> {
	NSInteger points;
}

@property(nonatomic, assign) BOOL canRedefine;
@property(nonatomic, retain) NSDecimalNumber *redefineCost;
@property(nonatomic, retain) NSDecimalNumber *orbitMin;
@property(nonatomic, retain) NSDecimalNumber *orbitMax;
@property(nonatomic, retain) NSDecimalNumber *growthMin;
@property(nonatomic, retain) NSString *redefineReason;
@property(nonatomic, retain) NSMutableDictionary *racialStats;
@property(nonatomic, retain) LETableViewCellTextEntry *speciesNameCell;
@property(nonatomic, retain) LETableViewCellLabeledTextView *speciesDescriptionCell;
@property(nonatomic, retain) LETableViewCellOrbitSelectorV2 *minOrbitCell;
@property(nonatomic, retain) LETableViewCellOrbitSelectorV2 *maxOrbitCell;
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


- (IBAction)redefineSpecies;


+ (EditSpeciesController *) create;


@end
