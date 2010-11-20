//
//  Entertainment.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Entertainment.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEBuildingGetLotteryVotingOptions.h"
#import "LEBuildingQuackDuck.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "ViewVotingOptionsController.h"
#import "ViewDuckQuackController.h"


@implementation Entertainment


@synthesize votingOptions;
@synthesize ducksQuacked;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.votingOptions = nil;
	self.ducksQuacked = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
	self.ducksQuacked = [Util asNumber:[data objectForKey:@"ducks_quacked"]];
}


- (void)generateSections {
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Party", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_VOTING_OPTIONS]), @"rows"), _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_DUCK_QUACKING], @"type", @"Duck Quacking", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_DUCKS_QUACKED], [NSDecimalNumber numberWithInt:BUILDING_ROW_QUACK_DUCK]), @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_VOTING_OPTIONS:
		case BUILDING_ROW_QUACK_DUCK:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_DUCKS_QUACKED:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_VOTING_OPTIONS:
			; //DO NOT REMOVE
			LETableViewCellButton *throwPartyCell = [LETableViewCellButton getCellForTableView:tableView];
			throwPartyCell.textLabel.text = @"View Lottery Voting Options";
			cell = throwPartyCell;
			break;
		case BUILDING_ROW_DUCKS_QUACKED:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *ducksQuackedCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			ducksQuackedCell.label.text = @"Ducks Quacked";
			ducksQuackedCell.content.text = [Util prettyNSDecimalNumber:self.ducksQuacked];
			cell = ducksQuackedCell;
			break;
		case BUILDING_ROW_QUACK_DUCK:
			; //DO NOT REMOVE
			LETableViewCellButton *quackDuckCell = [LETableViewCellButton getCellForTableView:tableView];
			quackDuckCell.textLabel.text = @"Quack Duck";
			cell = quackDuckCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_VOTING_OPTIONS:
			; //DO NOT REMOVE
			ViewVotingOptionsController *viewVotingOptionsController = [ViewVotingOptionsController create];
			viewVotingOptionsController.entertainment = self;
			return viewVotingOptionsController;
			break;
		case BUILDING_ROW_QUACK_DUCK:
			; //DO NOT REMOVE
			ViewDuckQuackController *viewDuckQuackController = [ViewDuckQuackController create];
			viewDuckQuackController.entertainment = self;
			return viewDuckQuackController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)loadVotingOptions {
	self.votingOptions = nil;
	self.needsRefresh = YES;
	[[[LEBuildingGetLotteryVotingOptions alloc] initWithCallback:@selector(loadedVotingOptions:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)removeVotingOptionNamed:(NSString *)votingOptionName {
	__block NSInteger foundIdx = -1;
	
	[self.votingOptions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
		if ([[obj objectForKey:@"name"] isEqualToString:votingOptionName]) {
			foundIdx = idx;
			*stop = YES;
		}
	}];
	
	if (foundIdx > -1) {
		[self.votingOptions removeObjectAtIndex:foundIdx];
	}
}


- (void)quackDuck:(id)target callback:(SEL)callback {
	self->duckQuackTarget = target;
	self->duckQuackCallback = callback;
	[[[LEBuildingQuackDuck alloc] initWithCallback:@selector(ducksQuacked:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)loadedVotingOptions:(LEBuildingGetLotteryVotingOptions *)request {
	self.votingOptions = request.votingOptions;
	self.needsRefresh = YES;
}


- (void)ducksQuacked:(LEBuildingQuackDuck *)request {
	self.needsRefresh = YES;
	self.ducksQuacked = [self.ducksQuacked decimalNumberByAdding:[NSDecimalNumber one]];
	[self->duckQuackTarget performSelector:self->duckQuackCallback withObject:request];
}


@end
