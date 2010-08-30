//
//  Network19.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Network19.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingRestrictCoverage.h"
#import "ViewNetwork19NewsController.h"


@implementation Network19


@synthesize restrictingCoverage;

#pragma mark -
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	self.restrictingCoverage = [[data objectForKey:@"restrict_coverage"] boolValue];
}


- (void)generateSections {
	NSMutableArray *network19Rows = [NSMutableArray arrayWithCapacity:2];
	[network19Rows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_VIEW_NETWORK_19]];
	if (self.restrictingCoverage) {
		[network19Rows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_RESTRICTED_NETWORK_19]];
	} else {
		[network19Rows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_UNRESTRICTED_NETWORK_19]];
	}
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Actions", @"name", network19Rows, @"rows"), [self generateHealthSection], [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuldingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_NETWORK_19:
		case BUILDING_ROW_RESTRICTED_NETWORK_19:
		case BUILDING_ROW_UNRESTRICTED_NETWORK_19:
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
		case BUILDING_ROW_VIEW_NETWORK_19:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *viewNewsButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			viewNewsButtonCell.textLabel.text = @"View Network 19 News";
			cell = viewNewsButtonCell;
			break;
		case BUILDING_ROW_RESTRICTED_NETWORK_19:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *restrictedButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			restrictedButtonCell.textLabel.text = @"News restricted, change";
			cell = restrictedButtonCell;
			break;
		case BUILDING_ROW_UNRESTRICTED_NETWORK_19:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *unrestrictedButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			unrestrictedButtonCell.textLabel.text = @"News unrestricted, change";
			cell = unrestrictedButtonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_VIEW_NETWORK_19:
			; //DO NOT REMOVE
			ViewNetwork19NewsController *viewNetwork19NewsController = [ViewNetwork19NewsController create];
			viewNetwork19NewsController.buildingId = self.id;
			viewNetwork19NewsController.urlPart = self.buildingUrl;
			return viewNetwork19NewsController;
			break;
		case BUILDING_ROW_RESTRICTED_NETWORK_19:
			[[[LEBuildingRestrictCoverage alloc] initWithCallback:@selector(buildingRestrictCoverageChanged:) target:self buildingId:self.id buildingUrl:self.buildingUrl restricted:NO] autorelease];
			return nil;
			break;
		case BUILDING_ROW_UNRESTRICTED_NETWORK_19:
			[[[LEBuildingRestrictCoverage alloc] initWithCallback:@selector(buildingRestrictCoverageChanged:) target:self buildingId:self.id buildingUrl:self.buildingUrl restricted:YES] autorelease];
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Callback Methods

- (id)buildingRestrictCoverageChanged:(LEBuildingRestrictCoverage *)request {
	self.needsReload = true;
	
	return nil;
}


@end
