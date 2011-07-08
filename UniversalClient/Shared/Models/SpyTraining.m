//
//  SpyTraining.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/30/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SpyTraining.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellCost.h"
#import "LEBuildingTrainSpy.h"
#import "ViewSpiesForTrainingController.h"
#import "LEBuildingTrainSpySkill.h"
#import "Spy.h"


@implementation SpyTraining


@synthesize spies;
@synthesize trainSpyTaget;
@synthesize trainSpyCallback;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.spies = nil;
    self.trainSpyCallback = nil;
    self.trainSpyTaget = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
    NSMutableDictionary *spyTrainingData = [data objectForKey:@"spies"];
    NSMutableDictionary *spyTrainingCostData = [spyTrainingData objectForKey:@"training_costs"];
    self.spies = [spyTrainingCostData objectForKey:@"time"];
}


- (void)generateSections {
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", _array([NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_SPIES_BUTTON]), @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_SPIES_BUTTON:
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
		case BUILDING_ROW_VIEW_SPIES_BUTTON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewSpiesButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewSpiesButtonCell.textLabel.text = @"View Spies";
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
		case BUILDING_ROW_VIEW_SPIES_BUTTON:
			; //DO NOT REMOVE
			ViewSpiesForTrainingController *viewSpiesForTrainingController = [ViewSpiesForTrainingController create];
			viewSpiesForTrainingController.spyTraining = self;
			return viewSpiesForTrainingController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)trainSpy:(NSString *)spyId target:(id)target callback:(SEL)callback {
    self.trainSpyTaget = target;
    self.trainSpyCallback = callback;
    [[[LEBuildingTrainSpySkill alloc] initWithCallback:@selector(spyTrained:) target:self buildingId:self.id buildingUrl:self.buildingUrl spyId:spyId] autorelease];
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:1];
    [self.spies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *spy = obj;
        if ([[Util idFromDict:spy named:@"spy_id"] isEqualToString:spyId]) {
            [toRemove addObject:spy];
        }
    }];
    [self.spies removeObjectsInArray:toRemove];
}


#pragma mark -
#pragma mark Callback Methods

- (void)spyTrained:(LEBuildingTrainSpySkill *)request {
    [self.trainSpyTaget performSelector:self.trainSpyCallback withObject:request];
    self.trainSpyCallback = nil;
    self.trainSpyTaget = nil;
}


@end
