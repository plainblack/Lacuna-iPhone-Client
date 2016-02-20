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
#import "AssembleGlyphsControllerV2.h"
#import "LEBuildingSubsidizeSearch.h"


@implementation Archaeology


@synthesize glyphs;
@synthesize availableOreTypes;
@synthesize secondsRemaining;
@synthesize delegate;


#pragma mark -
#pragma mark Object Methods

- (void)dealloc {
	self.glyphs = nil;
	self.availableOreTypes = nil;
	self.delegate = nil;
	[super dealloc];
}


- (NSString *)description {
	return [NSString stringWithFormat:@"secondsRemaining:%li, glyphs:%@", (long)self.secondsRemaining, self.glyphs];
}


#pragma mark -
#pragma mark Overriden Building Methods

- (BOOL)tick:(NSInteger)interval {
	BOOL reloadNeeded = [super tick:interval];
	if (self.secondsRemaining > 0) {
		self.secondsRemaining -= interval;
		
		if (self.secondsRemaining <= 0) {
			self.secondsRemaining = 0;
			reloadNeeded = YES;
		} else {
			self.needsRefresh = YES;
		}
	}
	return reloadNeeded;
}


- (void)parseAdditionalData:(NSDictionary *)data {
	NSDictionary *workData = [[data objectForKey:@"building"] objectForKey:@"work"];
	if (workData) {
		self.secondsRemaining = _intv([workData objectForKey:@"seconds_remaining"]);
	} else {
		self.secondsRemaining = 0;
	}

}


- (void)generateSections {
	
	NSMutableArray *glyphRows = [NSMutableArray arrayWithCapacity:2];
	if (self.secondsRemaining > 0) {
		[glyphRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_GLYPH_SEARCHING]];
		[glyphRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_SUBSIDIZE]];
	} else {
		[glyphRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_GLYPH_SEARCH]];
	}
	[glyphRows addObject:[NSDecimalNumber numberWithInt:BUILDING_ROW_GLYPH_ASSEMBLE]];

	self.sections = _array([self generateProductionSection], _dict([NSDecimalNumber numberWithInt:BUILDING_SECTION_ACTIONS], @"type", @"Glyphs", @"name", glyphRows, @"rows"), [self generateHealthSection], [self generateUpgradeSection], [self generateGeneralInfoSection]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForBuildingRow:(BUILDING_ROW)buildingRow {
	switch (buildingRow) {
		case BUILDING_ROW_GLYPH_SEARCH:
		case BUILDING_ROW_GLYPH_ASSEMBLE:
		case BUILDING_ROW_SUBSIDIZE:
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
			glyphAssmebleCell.textLabel.text = @"Assemble Glyphs";
			cell = glyphAssmebleCell;
			break;
		case BUILDING_ROW_GLYPH_SEARCHING:
			; //DO NOT REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellLabeledText *searchingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			searchingCell.label.text = @"Searching";
			searchingCell.content.text = [Util prettyDuration:self.secondsRemaining];
			cell = searchingCell;
			break;
		case BUILDING_ROW_SUBSIDIZE:
			; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
			LETableViewCellButton *subsidizeButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			subsidizeButtonCell.textLabel.text = @"Subsidize Search";
			cell = subsidizeButtonCell;
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
			AssembleGlyphsControllerV2 *assembleGlyphsControllerV2 = [AssembleGlyphsControllerV2 create];
			assembleGlyphsControllerV2.archaeology = self;
			return assembleGlyphsControllerV2;
			break;
		case BUILDING_ROW_SUBSIDIZE:
			[[[LEBuildingSubsidizeSearch alloc] initWithCallback:@selector(subsidizedSearch:) target:self buildingId:self.id buildingUrl:self.buildingUrl] autorelease];
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
			return @"This will cost you 2 essentia. Do you wish to continue?";
			break;
		default:
			return [super confirmMessage:indexPath];
			break;
	}
}


#pragma mark -
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


#pragma mark -
#pragma mark Callback Methods

- (id)glyphAssembeled:(LEBuildingGlyphAssemble *)request {
	if ([request wasError]) {
		[self.delegate assembleyFailed:[request errorMessage]];
		[request markErrorHandled];
	} else {
		[self.delegate assembleyComplete:request.itemName];
	}

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
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
	self.needsRefresh = YES;
	return nil;
}


- (id)subsidizedSearch:(LEBuildingSubsidizeSearch *)request {
	[self parseData:request.result];
	[[self findMapBuilding] parseData:[request.result objectForKey:@"building"]];
	self.needsRefresh = YES;
	return nil;
}


@end
