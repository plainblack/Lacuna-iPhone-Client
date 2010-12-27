//
//  ThemePark.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ThemePark.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLongLabeledText.h"
#import "LETableViewCellParagraph.h"
#import "LEBuildingOperate.h"


@implementation ThemePark


@synthesize canOperate;
@synthesize foodTypeCount;
@synthesize reason;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.foodTypeCount = nil;
	self.reason = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Overriden Building Methods

- (void)parseAdditionalData:(NSDictionary *)data {
	NSDictionary *themeParkData = [data objectForKey:@"themepark"];
	NSLog(@"Theme Park Data: %@", themeParkData);
	self.canOperate = [[themeParkData objectForKey:@"can_operate"] boolValue];
	self.foodTypeCount = [Util asNumber:[themeParkData objectForKey:@"food_type_count"]];
	self.reason = [themeParkData objectForKey:@"reason"];
}


- (void)generateSections {
	NSMutableArray *partyRows = [NSMutableArray arrayWithCapacity:2];
	if (self.canOperate) {
		[partyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_OPERATE]];
	}
	if (isNotNull(self.foodTypeCount)) {
		[partyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_FOOD_TYPE_COUNT]];
	}
	if (isNotNull(self.reason) && ([self.reason length] > 0)) {
		[partyRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_CANNOT_OPERATE_REASON]];
	}
	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Operate", @"name", partyRows, @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_OPERATE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_FOOD_TYPE_COUNT:
			return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_CANNOT_OPERATE_REASON:
			return [LETableViewCellParagraph getHeightForTableView:tableView text:self.reason];
			break;
		default:
			return [super tableView:tableView heightForBuildingRow:buildingRow];
			break;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	UITableViewCell *cell = nil;
	switch (buildingRow) {
		case BUILDING_ROW_OPERATE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *operateCell = [LETableViewCellButton getCellForTableView:tableView];
			if (self.foodTypeCount) {
				operateCell.textLabel.text = @"Extend Operation";
			} else {
				operateCell.textLabel.text = @"Operate Theme Park";
			}
			cell = operateCell;
			break;
		case BUILDING_ROW_FOOD_TYPE_COUNT:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLongLabeledText *foodTypeCountCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
			foodTypeCountCell.label.text = @"# Food Types need to extend";
			foodTypeCountCell.content.text = [Util prettyNSDecimalNumber:self.foodTypeCount];
			cell = foodTypeCountCell;
			break;
		case BUILDING_ROW_CANNOT_OPERATE_REASON:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellParagraph *reasonCell = [LETableViewCellParagraph getCellForTableView:tableView];
			reasonCell.content.text = self.reason;
			cell = reasonCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_OPERATE:
			[[[LEBuildingOperate alloc] initWithCallback:@selector(operating:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark -
#pragma mark Callback Methods

- (id)operating:(LEBuildingOperate *)request {
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
	self.needsRefresh = YES;
	return nil;
}



@end
