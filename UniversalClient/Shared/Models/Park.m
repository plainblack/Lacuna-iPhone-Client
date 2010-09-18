//
//  Park.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Park.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledIconText.h"
#import "LEBuildingThrowParty.h"


@implementation Park

@synthesize canThrowParty;
@synthesize secondsRemaining;
@synthesize happinessPerParty;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.happinessPerParty = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	NSLog(@"Tick");
	if (self.secondsRemaining > 0) {
		self.secondsRemaining -= interval;
		if (self.secondsRemaining <= 0) {
			self.secondsRemaining = 0;
			self.needsReload = YES;
		} else {
			self.needsRefresh = YES;
		}
	}
	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	NSDictionary *partyData = [data objectForKey:@"party"];
	self.canThrowParty = [[partyData objectForKey:@"can_throw"] boolValue];
	self.secondsRemaining = _intv([partyData objectForKey:@"seconds_remaining"]);
	self.happinessPerParty = [Util asNumber:[partyData objectForKey:@"happiness"]];
}


- (void)generateSections {
	
	NSMutableArray *partyRows = [NSMutableArray arrayWithCapacity:2];
	if (self.canThrowParty) {
		[partyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_THROW_PARTY]];
	} else {
		[partyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_PARTY_PENDING]];
	}
	[partyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_PARTY_HAPPINESS]];
	
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Party", @"name", partyRows, @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_THROW_PARTY:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_PARTY_PENDING:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_PARTY_HAPPINESS:
			return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_THROW_PARTY:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *throwPartyCell = [LETableViewCellButton getCellForTableView:tableView];
			throwPartyCell.textLabel.text = @"Throw Party";
			cell = throwPartyCell;
			break;
		case BUILDING_ROW_PARTY_PENDING:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *partyPendingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			if (self.secondsRemaining > 0) {
				partyPendingCell.label.text = @"In progress";
				partyPendingCell.content.text = [Util prettyDuration:self.secondsRemaining];
			} else {
				partyPendingCell.label.text = @"Party";
				partyPendingCell.content.text = @"Not enough food";
			}
			cell = partyPendingCell;
			break;
		case BUILDING_ROW_PARTY_HAPPINESS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledIconText *happinessGeneratesCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
			happinessGeneratesCell.label.text = @"Generates";
			happinessGeneratesCell.icon.image = HAPPINESS_ICON;
			happinessGeneratesCell.content.text = [Util prettyNSDecimalNumber:self.happinessPerParty];
			cell = happinessGeneratesCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_THROW_PARTY:
			[[[LEBuildingThrowParty alloc] initWithCallback:@selector(throwingParty:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Callback Methods

- (id)throwingParty:(LEBuildingThrowParty *)request {
	self.needsReload = YES;
	return nil;
}


@end
