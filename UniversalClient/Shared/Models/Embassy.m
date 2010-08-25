//
//  Embassy.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Embassy.h"
#import "LEMacros.h"


@implementation Embassy


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	[super dealloc];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data {
	NSLog(@"Embassy Data: %@", data);
}


- (void)generateSections {
	self.sections = _array([self generateProductionSection], [self generateHealthSection], [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		default:
			cell = [super tableView:tableView cellForBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


@end
