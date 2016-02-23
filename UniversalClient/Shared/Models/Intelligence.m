//
//  Intelligence.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Intelligence.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellCost.h"
#import "LEBuildingTrainSpy.h"
#import "ViewSpiesController.h"
#import "LEBuildingAssignSpy.h"
#import "LEBuildingBurnSpy.h"
#import "LEBuildingNameSpy.h"
#import "LEBuildingViewSpies.h"
#import "LEBuildingSubsidizeTraining.h"
#import "Spy.h"


@implementation Intelligence


@synthesize maxSpies;
@synthesize numSpies;
@synthesize spyTrainingCost;
@synthesize spies;
@synthesize possibleAssignments;
@synthesize spiesUpdated;
@synthesize spyPageNumber;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.maxSpies = nil;
	self.numSpies = nil;
	self.spyTrainingCost = nil;
	self.spies = nil;
	self.possibleAssignments = nil;
	self.spiesUpdated = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (BOOL)tick:(NSInteger)interval {
	BOOL reloadSpies = NO;

	if (self.spies) {
		for (Spy *spy in self.spies) {
			if ([spy tick:interval]) {
				reloadSpies = YES;
			}
		}
	}

	if (reloadSpies) {
		[self loadSpiesForPage:self.spyPageNumber];
	}

	self.spiesUpdated = [NSDate date];
	
	return [super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	NSDictionary *spyData = [data objectForKey:@"spies"];
	self.maxSpies = [Util asNumber:[spyData objectForKey:@"maximum"]];
	self.numSpies = [Util asNumber:[spyData objectForKey:@"current"]];
	if (!self.spyTrainingCost) {
		self.spyTrainingCost = [[[ResourceCost alloc] init] autorelease];
	}
	[self.spyTrainingCost parseData:[spyData objectForKey:@"training_costs"]];
}


- (void)generateSections {
	NSMutableArray *spyRows = [NSMutableArray arrayWithCapacity:5];
	[spyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_NUM_SPIES]];
	[spyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_SPY_BUILD_COST]];
	[spyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_SPIES_BUTTON]];
	
	[spyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_SUBSIDIZE]];
	
	if ([self.numSpies compare:self.maxSpies] == NSOrderedAscending) {
		[spyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_BUILD_SPY_BUTTON]];
	}

	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Spies", @"name", spyRows, @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_SPY_BUILD_COST:
			return [LETableViewCellCost getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_BUILD_SPY_BUTTON:
		case BUILDING_ROW_VIEW_SPIES_BUTTON:
		case BUILDING_ROW_SUBSIDIZE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_NUM_SPIES:
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
		case BUILDING_ROW_NUM_SPIES:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *numSpiesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			numSpiesCell.label.text = @"Spies";
			numSpiesCell.content.text = [NSString stringWithFormat:@"%@/%@", self.numSpies, self.maxSpies];
			cell = numSpiesCell;
			break;
		case BUILDING_ROW_SPY_BUILD_COST:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellCost *buildSpyCostCell = [LETableViewCellCost getCellForTableView:tableView];
			[buildSpyCostCell setResourceCost:self.spyTrainingCost];
			cell = buildSpyCostCell;
			break;
		case BUILDING_ROW_BUILD_SPY_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *buildSpyButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			buildSpyButtonCell.textLabel.text = @"Train Spy";
			cell = buildSpyButtonCell;
			break;
		case BUILDING_ROW_VIEW_SPIES_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewSpiesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewSpiesButtonCell.textLabel.text = @"View Spies";
			cell = viewSpiesButtonCell;
			break;
		case BUILDING_ROW_SUBSIDIZE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *subsidizeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			subsidizeButtonCell.textLabel.text = @"Subsidize Training";
			cell = subsidizeButtonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_BUILD_SPY_BUTTON:
			[[[LEBuildingTrainSpy alloc] initWithCallback:@selector(spyTrained:) target:self buildingId:self.id buildingUrl:self.buildingUrl quantity:[Util decimalFromInt:1]] autorelease];
			return nil;
			break;
		case BUILDING_ROW_VIEW_SPIES_BUTTON:
			; //DO NOT REMOVE
			ViewSpiesController *viewSpiesController = [ViewSpiesController create];
			viewSpiesController.intelligenceBuilding = self;
			return viewSpiesController;
			break;
		case BUILDING_ROW_SUBSIDIZE:
			[[[LEBuildingSubsidizeTraining alloc] initWithCallback:@selector(subsidizedTraining:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


- (BOOL)isConfirmCell:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	switch (_intv([rows objectAtIndex:indexPath.row])) {
		case BUILDING_ROW_SUBSIDIZE:
			return YES;
			break;
		default:
			return [super isConfirmCell:indexPath];
			break;
	}
}


- (NSString *)confirmMessage:(NSIndexPath *)indexPath {
	NSDictionary *section = [self.sections objectAtIndex:indexPath.section];
	NSArray *rows = [section objectForKey:@"rows"];
	
	switch (_intv([rows objectAtIndex:indexPath.row])) {
		case BUILDING_ROW_SUBSIDIZE:
			return @"This will cost you 1 essentia per spy training. Do you wish to continue?";
			break;
		default:
			return [super confirmMessage:indexPath];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)loadSpiesForPage:(NSInteger)pageNumber {
	self.spyPageNumber = pageNumber;
	[[[LEBuildingViewSpies alloc] initWithCallback:@selector(spiesLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl pageNumber:pageNumber] autorelease];

}


- (void)burnSpy:(Spy *)spy {
	[[[LEBuildingBurnSpy alloc] initWithCallback:@selector(spyBurnt:) target:self buildingId:self.id buildingUrl:self.buildingUrl spyId:spy.id] autorelease];
}


- (void)spy:(Spy *)spy rename:(NSString *)newName {
	[[[LEBuildingNameSpy alloc] initWithCallback:@selector(spyRenamed:) target:self buildingId:self.id buildingUrl:self.buildingUrl	spyId:spy.id name:newName] autorelease];
}


- (void)spy:(Spy *)spy assign:(NSString *)assignment target:(id)target callback:(SEL)callback {
	self->assignSpyTarget = target;
	self->assignSpyCallback = callback;
	[[[LEBuildingAssignSpy alloc] initWithCallback:@selector(spyAssigned:) target:self buildingId:self.id buildingUrl:self.buildingUrl spyId:spy.id assignment:assignment] autorelease];
}


-(bool)hasPreviousSpyPage {
	return (self.spyPageNumber > 1);
}


- (bool)hasNextSpyPage {
	return (self.spyPageNumber < [Util numPagesForCount:_intv(self.numSpies)]);
}


#pragma mark -
#pragma mark Callback Methods

- (id)spyTrained:(LEBuildingTrainSpy *)request {
	self.numSpies = [self.numSpies decimalNumberByAdding:request.trained];
	if (_intv(request.notTrained) > 0) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Warning" message: @"Your spy could not be trained. You probably don't have enough resources to train one." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
	}
	[self generateSections];
	self.needsRefresh = YES;
	
	self.spies = nil;
	self.spiesUpdated = [NSDate date];
	return nil;
}


- (id)spiesLoaded:(LEBuildingViewSpies *)request {
	NSMutableArray *tmpSpies = [NSMutableArray arrayWithCapacity:[request.spies count]];
	for (NSDictionary *spyData in request.spies) {
		Spy *tmpSpy = [[[Spy alloc] init] autorelease];
		[tmpSpy parseData:spyData];
		[tmpSpies addObject:tmpSpy];
	}
	
	self.possibleAssignments = request.possibleAssignments;
	self.spies = tmpSpies;
	
	self.spiesUpdated = [NSDate date];
	return nil;
}


- (id)spyBurnt:(LEBuildingBurnSpy *)request {
	self.numSpies = [self.numSpies decimalNumberBySubtracting:[NSDecimalNumber one]];
	Spy *spyToRemove = nil;
	for (Spy *newSpy in self.spies) {
		if ([newSpy.id isEqualToString:request.spyId]) {
			spyToRemove = newSpy;
		}
	}
	if (spyToRemove) {
		[self.spies removeObject:spyToRemove];
	}
	
	self.spiesUpdated = [NSDate date];
	[self generateSections];
	self.needsRefresh = YES;
	return nil;
}


- (id)spyRenamed:(LEBuildingNameSpy *)request {
	__block Spy *renamedSpy = nil;
    [self.spies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Spy *spy = obj;
		if ([spy.id isEqualToString:request.spyId]) {
			renamedSpy = spy;
            *stop = YES;
		}
    }];
	self.spiesUpdated = [NSDate date];
	renamedSpy.name = request.name;
	return nil;
}


- (id)spyAssigned:(LEBuildingAssignSpy *)request {
	Spy *assignedSpy = nil;
	for (Spy *spy in self.spies) {
		if ([spy.id isEqualToString:request.spyId]) {
			assignedSpy = spy;
		}
	}
	
	[assignedSpy parseData:request.spyData];
	if (request.mission) {
		[request.mission setObject:assignedSpy forKey:@"spy"];
		[self->assignSpyTarget performSelector:self->assignSpyCallback withObject:request.mission];
	}
	self.spiesUpdated = [NSDate date];

	return nil;
}


- (id)subsidizedTraining:(LEBuildingSubsidizeTraining *)request {
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
	self.spies = nil;
	self.needsRefresh = YES;
	return nil;
}


@end
