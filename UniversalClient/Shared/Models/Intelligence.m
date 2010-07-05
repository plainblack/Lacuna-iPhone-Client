//
//  Intelligence.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Intelligence.h"
#import "LEMacros.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellCost.h"
#import "LEBuildingTrainSpy.h"
#import "ViewSpiesController.h"


@implementation Intelligence

@synthesize maxSpies;
@synthesize numSpies;
@synthesize spyTrainingCost;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.spyTrainingCost = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	//Tick spies once I have list of spies
	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data tmpSections:(NSMutableArray *)tmpSections {
	NSDictionary *spyData = [data objectForKey:@"spies"];
	self.maxSpies = _intv([spyData objectForKey:@"maximum"]);
	self.numSpies = _intv([spyData objectForKey:@"current"]);
	if (!self.spyTrainingCost) {
		self.spyTrainingCost = [[[ResourceCost alloc] init] autorelease];
	}
	NSLog(@"Parsing spy training cost!");
	[self.spyTrainingCost parseData:[spyData objectForKey:@"training_costs"]];
	
	NSMutableArray *rows = [NSMutableArray arrayWithCapacity:5];
	[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_NUM_SPIES]];
	[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_SPY_BUILD_COST]];
	
	if (self.numSpies < self.maxSpies) {
		[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_BUILD_SPY_BUTTON]];
	}
	
	[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_VIEW_SPIES_BUTTON]];
	[tmpSections addObject:_dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Spies", @"name", rows, @"rows")];
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_SPY_BUILD_COST:
			return 65.0;
			break;
		case BUILDING_ROW_BUILD_SPY_BUTTON:
		case BUILDING_ROW_VIEW_SPIES_BUTTON:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_NUM_SPIES:
			return tableView.rowHeight;
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
			LETableViewCellLabeledText *numSpiesCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			numSpiesCell.label.text = @"Spies";
			numSpiesCell.content.text = [NSString stringWithFormat:@"%i/%i", self.numSpies, self.maxSpies];
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
			buildSpyButtonCell.textLabel.text = @"Build spy";
			cell = buildSpyButtonCell;
			break;
		case BUILDING_ROW_VIEW_SPIES_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewSpiesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewSpiesButtonCell.textLabel.text = @"View spies";
			cell = viewSpiesButtonCell;
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
			[[[LEBuildingTrainSpy alloc] initWithCallback:@selector(spyTrained:) target:self buildingId:self.id buildingUrl:self.buildingUrl quantity:[NSNumber numberWithInt:1]] autorelease];
			return nil;
			break;
		case BUILDING_ROW_VIEW_SPIES_BUTTON:
			; //DO NOT REMOVE
			ViewSpiesController *viewSpiesController = [ViewSpiesController create];
			viewSpiesController.buildingId = self.id;
			//viewSpiesController.spiesData = [self.resultData objectForKey:@"spies"];
			viewSpiesController.urlPart = self.buildingUrl;
			return viewSpiesController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Callback Methods

- (id)spyTrained:(LEBuildingTrainSpy *)request {
	self.numSpies += _intv(request.trained);
	if (_intv(request.notTrained) > 0) {
		NSLog(@"KEVIN ADD ALERT!!");
	}
	self.needsRefresh = YES;
	return nil;
}


@end
