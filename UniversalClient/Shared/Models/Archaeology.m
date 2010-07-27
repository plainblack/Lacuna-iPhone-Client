//
//  Archaeology.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Archaeology.h"
#import "Glyph.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingGlyphs.h"
#import "LEBuildingGlyphAssemble.h"
#import "LEBuildingGlyphSearch.h"
#import "LEBuildingGetOresAvailableForProcessing.h"
#import "SearchForGlyphController.h"
#import "AssembleGlyphsController.h"


@implementation Archaeology


@synthesize glyphs;
@synthesize availableOreTypes;
@synthesize itemName;
@synthesize secondsRemaining;
@synthesize delegate;


#pragma mark --
#pragma mark Object Methods

- (void)dealloc {
	self.glyphs = nil;
	self.availableOreTypes = nil;
	self.itemName = nil;
	self.delegate = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"secondsRemaining:%i, glyphs:%@", self.secondsRemaining, self.glyphs];
}


#pragma mark --
#pragma mark Overriden Building Methods

- (void)tick:(NSInteger)interval {
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
	NSDictionary *workData = [data objectForKey:@"work"];
	if (workData) {
		self.secondsRemaining = _intv([workData objectForKey:@"seconds_remaining"]);
	}
}


- (void)generateSections {
	
	NSMutableArray *glyphRows = [NSMutableArray arrayWithCapacity:2];
	if (self.secondsRemaining > 0) {
		[glyphRows addObject:[NSNumber numberWithInt:BUILDING_ROW_GLYPH_SEARCHING]];
	} else {
		[glyphRows addObject:[NSNumber numberWithInt:BUILDING_ROW_GLYPH_SEARCH]];
	}
	[glyphRows addObject:[NSNumber numberWithInt:BUILDING_ROW_GLYPH_ASSEMBLE]];

	self.sections = _array([self generateProductionSection], _dict([NSNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Glyphs", @"name", glyphRows, @"rows"), [self generateUpgradeSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_GLYPH_SEARCH:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_GLYPH_ASSEMBLE:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case BUILDING_ROW_GLYPH_SEARCHING:
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
		case BUILDING_ROW_GLYPH_SEARCH:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *glyphSearchCell = [LETableViewCellButton getCellForTableView:tableView];
			glyphSearchCell.textLabel.text = @"Search for Glyphs";
			cell = glyphSearchCell;
			break;
		case BUILDING_ROW_GLYPH_ASSEMBLE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *glyphAssmebleCell = [LETableViewCellButton getCellForTableView:tableView];
			glyphAssmebleCell.textLabel.text = @"Assemble Glyhphs";
			cell = glyphAssmebleCell;
			break;
		case BUILDING_ROW_GLYPH_SEARCHING:
			; //DO NOT REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *searchingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			searchingCell.label.text = @"Searching";
			searchingCell.content.text = [Util prettyDuration:self.secondsRemaining];
			cell = searchingCell;
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
			; //DO NOT REMOVE
			SearchForGlyphController *searchForGlyphController = [SearchForGlyphController create];
			searchForGlyphController.archaeology = self;
			return searchForGlyphController;
			break;
		case BUILDING_ROW_GLYPH_ASSEMBLE:
			; //DO NOT REMOVE
			AssembleGlyphsController *assembleGlyphsController = [AssembleGlyphsController create];
			assembleGlyphsController.archaeology = self;
			return assembleGlyphsController;
			break;
		default:
			return [super tableView:tableView didSelectBuildingRow:buildingRow rowIndex:rowIndex];
			break;
	}
}


#pragma mark --
#pragma mark Instance Methods

- (void)assembleGlyphs:(NSArray *)inGlyphs {
	[[[LEBuildingGlyphAssemble alloc] initWithCallback:@selector(glyphAssembeled:) target:self buildingId:self.id buildingUrl:self.buildingUrl glyphIds:inGlyphs] autorelease];
}


- (void)loadAvailableOreTypes {
	[[[LEBuildingGetOresAvailableForProcessing alloc] initWithCallback:@selector(oresAvailableForProcessingLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)loadGlyphs {
	[[[LEBuildingGlyphs alloc] initWithCallback:@selector(glyphsLoaded:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
}


- (void)searchForGlyph:(NSString *)oreType {
	[[[LEBuildingGlyphSearch alloc] initWithCallback:@selector(searchedForGlyph:) target:self buildingId:self.id buildingUrl:self.buildingUrl oreType:oreType] autorelease];
}


#pragma mark --
#pragma mark Callback Methods

- (id)glyphAssembeled:(LEBuildingGlyphAssemble *)request {
	self.itemName = request.itemName;
	[self.delegate assembleyComplete];
	return nil;
}


- (id)glyphsLoaded:(LEBuildingGlyphs *)request {
	Glyph *glyph;
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[request.glyphs count]];
	
	for (NSDictionary *glyphData in request.glyphs) {
		glyph = [[[Glyph alloc] init] autorelease];
		[glyph parseData:glyphData];
		[tmp addObject:glyph];
	}
	self.glyphs = tmp;
	
	return nil;
}


- (id)oresAvailableForProcessingLoaded:(LEBuildingGetOresAvailableForProcessing *)request {
	self.availableOreTypes = request.oreTypes;
	
	return nil;
}


- (id)searchedForGlyph:(LEBuildingGlyphSearch *)request {
	self.secondsRemaining = request.secondsRemaining;
	[self generateSections];
	self.needsRefresh;
	return nil;
}


@end
