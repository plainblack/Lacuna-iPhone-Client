//
//  Archaeology.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Archaeology.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"


@implementation Archaeology


@synthesize glyphs;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.glyphs = nil;
	[super dealloc];
}

#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
	NSLog(@"Archaeology Tick");
	[super tick:interval];
}


- (void)parseAdditionalData:(NSDictionary *)data tmpSections:(NSMutableArray *)tmpSections {
	self.glyphs = [NSMutableArray arrayWithCapacity:0];
	
	NSMutableArray *rows = [NSMutableArray arrayWithCapacity:2];
	[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_GLYPH_SEARCH]];
	[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_GLYPH_VIEW]];
	[rows addObject:[NSNumber numberWithInt:BUILDING_ROW_GLYPH_ASSEMBLE]];
	[tmpSections addObject:_dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Glyphs", @"name", rows, @"rows")];
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_GLYPH_SEARCH:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_GLYPH_VIEW:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_GLYPH_ASSEMBLE:
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
		case BUILDING_ROW_GLYPH_SEARCH:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *glyphSearchCell = [LETableViewCellButton getCellForTableView:tableView];
			glyphSearchCell.textLabel.text = @"Search for Glyphs";
			cell = glyphSearchCell;
			break;
		case BUILDING_ROW_GLYPH_VIEW:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *glyphViewCell = [LETableViewCellButton getCellForTableView:tableView];
			glyphViewCell.textLabel.text = @"View Glyphs";
			cell = glyphViewCell;
			break;
		case BUILDING_ROW_GLYPH_ASSEMBLE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *glyphAssmebleCell = [LETableViewCellButton getCellForTableView:tableView];
			glyphAssmebleCell.textLabel.text = @"Assemble Glyhphs";
			cell = glyphAssmebleCell;
			break;
		default:
			cell = [super tableView:tableView cellForBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex];
			break;
	}
	
	return cell;
}


- (UIViewController *)tableView:(UITableView *)tableView didSelectBuildingRow:(BUILDING_ROW)buildingRow rowIndex:(NSInteger)rowIndex {
	switch (buildingRow) {
		case BUILDING_ROW_GLYPH_SEARCH:
			NSLog(@"Glyph Search TBD");
			return nil;
			break;
		case BUILDING_ROW_GLYPH_VIEW:
			NSLog(@"Glyph View TBD");
			return nil;
			break;
		case BUILDING_ROW_GLYPH_ASSEMBLE:
			NSLog(@"Glyph Assemble TBD");
			return nil;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


@end
