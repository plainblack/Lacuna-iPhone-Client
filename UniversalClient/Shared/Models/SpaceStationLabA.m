//
//  SpaceStationLab.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/18/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SpaceStationLabA.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingMakePlan.h"
#import "LEBuildingSubsidizePlan.h"
#import "MakePlanViewController.h"


@implementation SpaceStationLabA


@synthesize makePlanTaget;
@synthesize makePlanCallback;
@synthesize types;
@synthesize levels;
@synthesize subsidyCost;
@synthesize making;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
    self.makePlanTaget = nil;
    self.makePlanCallback = nil;
    self.types = nil;
    self.levels = nil;
    self.subsidyCost = nil;
    self.making = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
    NSMutableDictionary *makePlanData = [data objectForKey:@"make_plan"];
    self.types = [makePlanData objectForKey:@"types"];
    self.levels = [makePlanData objectForKey:@"level_costs"];
	self.subsidyCost = [Util asNumber:[makePlanData objectForKey:@"subsidy_cost"]];
    self.making = [makePlanData objectForKey:@"making"];
}


- (void)generateSections {
    NSMutableArray *rows;
    
    if (self.making) {
        rows = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_MAKING], [NSDecimalNumber numberWithInt:BUILDING_ROW_SUBSIDIZE]);
    } else {
        rows = _array([NSDecimalNumber numberWithInt:BUILDING_ROW_MAKE_PLAN]);
    }
	
	NSMutableDictionary *actionSection = _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", rows, @"rows");
    
	self.sections = _array([self generateProductionSection], actionSection, [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_SUBSIDIZE:
		case BUILDING_ROW_MAKE_PLAN:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_MAKING:
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
		case BUILDING_ROW_SUBSIDIZE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *subsidizePlanCell = [LETableViewCellButton getCellForTableView:tableView];
			subsidizePlanCell.textLabel.text = [NSString stringWithFormat:@"Subsidize Plan (%@)", self.subsidyCost];
			cell = subsidizePlanCell;
			break;
		case BUILDING_ROW_MAKE_PLAN:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *makePlanCell = [LETableViewCellButton getCellForTableView:tableView];
			makePlanCell.textLabel.text = @"Make Plan";
			cell = makePlanCell;
			break;
		case BUILDING_ROW_MAKING:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *makingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			makingCell.label.text = @"Making";
            makingCell.content.text = self.making;
			cell = makingCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_SUBSIDIZE:
            [[[LEBuildingSubsidizePlan alloc] initWithCallback:@selector(planSubsidized:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
            return nil;
			break;
		case BUILDING_ROW_MAKE_PLAN:
			; //DO NOT REMOVE
			MakePlanViewController *makePlanViewController = [MakePlanViewController create];
			makePlanViewController.spaceStationLab = self;
			return makePlanViewController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (void)makePlanType:(NSString *)type level:(NSDecimalNumber *)level target:(id)inMakePlanTaget callback:(SEL)inMakePlanCallback {
    self.makePlanTaget = inMakePlanTaget;
    self.makePlanCallback = inMakePlanCallback;
    [[[LEBuildingMakePlan alloc] initWithCallback:@selector(makingPlan:) target:self buildingId:self.id buildingUrl:self.buildingUrl type:type level:level] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)makingPlan:(LEBuildingMakePlan *)request {
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
	self.needsRefresh = YES;
    [self.makePlanTaget performSelector:self.makePlanCallback withObject:request];
    self.makePlanTaget = nil;
    self.makePlanCallback = nil;
}


- (void)planSubsidized:(LEBuildingSubsidizePlan *)request {
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
	self.needsRefresh = YES;
}



@end
