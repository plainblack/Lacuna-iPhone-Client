//
//  SelectGlyphController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectGlyphController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Archaeology.h"
#import "BaseTradeBuilding.h"
#import "Glyph.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellGlyph.h"


@interface SelectGlyphController (PrivateMethods)

- (void)setMyGlyphsTo:(NSMutableArray *)myGlyphs;

@end


@implementation SelectGlyphController

@synthesize archaeology;
@synthesize baseTradeBuilding;
@synthesize filterGlyphs;
@synthesize glyphs;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Glyph";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if (self.archaeology) {
		[self.archaeology addObserver:self forKeyPath:@"glyphs" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
		if (!self.archaeology.glyphs) {
			[self.archaeology loadGlyphs];
		} else {
			[self setMyGlyphsTo:self.archaeology.glyphs];
		}
	} else {
		[self.baseTradeBuilding addObserver:self forKeyPath:@"glyphs" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
		if (!self.baseTradeBuilding.glyphs) {
			[self.baseTradeBuilding loadTradeableGlyphs];
		} else {
			[self setMyGlyphsTo:self.baseTradeBuilding.glyphs];
		}
	}
	if (self.glyphs) {
		[self.glyphs sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease])];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	if (self.archaeology) {
		[self.archaeology removeObserver:self forKeyPath:@"glyphs"];
	} else {
		[self.baseTradeBuilding removeObserver:self forKeyPath:@"glyphs"];
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.glyphs) {
		if ([self.glyphs count] > 0) {
			return [self.glyphs count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.glyphs) {
		if ([self.glyphs count] > 0) {
			return [LETableViewCellGlyph getHeightForTableView:tableView];
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
	
	if (self.glyphs) {
		if ([self.glyphs count] > 0) {
			Glyph *glyph = [self.glyphs objectAtIndex:indexPath.row];
			LETableViewCellGlyph *glyphCell = [LETableViewCellGlyph getCellForTableView:tableView isSelectable:YES];
			[glyphCell setGlyph:glyph];
			cell = glyphCell;
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Glyphs";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Glyphs";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Glyph *glyph = [self.glyphs objectAtIndex:indexPath.row];
	[self.delegate glyphSelected:glyph];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.glyphs = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.archaeology = nil;
	self.baseTradeBuilding = nil;
	self.filterGlyphs = nil;
	self.glyphs = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)setMyGlyphsTo:(NSMutableArray *)myGlyphs {
	self.glyphs = [myGlyphs mutableCopy];
	if (self.filterGlyphs) {
		[self.glyphs removeObjectsInArray:self.filterGlyphs];
	}
	[self.glyphs sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease])];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectGlyphController *)create {
	return [[[SelectGlyphController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"glyphs"]) {
		if (self.archaeology) {
			[self setMyGlyphsTo:self.archaeology.glyphs];
		} else {
			[self setMyGlyphsTo:self.baseTradeBuilding.glyphs];
		}
		[self.tableView reloadData];
	}
}


@end

