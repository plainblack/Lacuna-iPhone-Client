//
//  Observatory.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Observatory.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEBuildingViewProbedStars.h"
#import "LEBuildingAbandonProbe.h"
#import "LETableViewCellButton.h"
#import "ViewProbedStarsController.h"


@implementation Observatory


@synthesize probedStars;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.probedStars = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"probedStars:%@", self.probedStars];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	[super tick:interval];
}


- (void)generateSections {
	
	NSMutableDictionary *productionSection = [self generateProductionSection];
	
	NSMutableArray *actionRows = [NSMutableArray arrayWithCapacity:1];
	[actionRows addObject:[NSNumber numberWithInt:BUILDING_ROW_VIEW_PROBED_STARS]];
	
	self.sections = _array(productionSection, [self generateHealthSection], _dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", actionRows, @"rows"), [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PROBED_STARS:
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
		case BUILDING_ROW_VIEW_PROBED_STARS:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewShipBuildQueueCell = [LETableViewCellButton getCellForTableView:tableView];
			viewShipBuildQueueCell.textLabel.text = @"View Probed Stars";
			cell = viewShipBuildQueueCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_PROBED_STARS:
			; //DO NOT REMOVE
			ViewProbedStarsController *viewProbedStarsController = [ViewProbedStarsController create];
			viewProbedStarsController.observatory = self;
			return viewProbedStarsController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Instance Methods

- (void)loadProbedStars {
	[[[LEBuildingViewProbedStars alloc] initWithCallback:@selector(probedStarsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)abandonProbeAtStar:(NSString *)starId {
	[[[LEBuildingAbandonProbe alloc] initWithCallback:@selector(probeAbandoned:) target:self buildingId:self.id buildingUrl:self.buildingUrl starId:starId] autorelease];
}


#pragma mark --
#pragma mark Callback Methods

- (id)probedStarsLoaded:(LEBuildingViewProbedStars *)request {
	NSLog(@"Probjed Star Data: %@", request.response);
	self.probedStars = request.probedStars;
	return nil;
}


- (id)probeAbandoned:(LEBuildingAbandonProbe *)request {
	return nil;
}


@end
