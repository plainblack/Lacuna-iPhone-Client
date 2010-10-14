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
#import "LETableViewCellButton.h"
#import "LEBuildingGetLotteryVotingOptions.h"
#import "ViewVotingOptionsController.h"


@implementation Entertainment


@synthesize votingOptions;


#pragma mark -
#pragma mark Overriden Building Methods

- (void)generateSections {
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Party", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_VOTING_OPTIONS]), @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_VOTING_OPTIONS:
			return [LETableViewCellButton getHeightForTableView:tableView];
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
			return nil;
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


#pragma mark -
#pragma mark Callback Methods

- (void)loadedVotingOptions:(LEBuildingGetLotteryVotingOptions *)request {
	self.votingOptions = request.votingOptions;
	self.needsRefresh = YES;
}


@end
