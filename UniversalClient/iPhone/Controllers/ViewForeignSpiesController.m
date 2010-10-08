//
//  ViewForeignSpies.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/6/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewForeignSpiesController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "Util.h"
#import "Security.h"


typedef enum {
	ROW_NAME,
	ROW_LEVEL,
	ROW_NEXT_MISSION
} ROW;


@interface ViewForeignSpiesController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewForeignSpiesController


@synthesize pageSegmentedControl;
@synthesize securityBuilding;
@synthesize foreignSpiesLastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Foreign Spies";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	self.pageSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.securityBuilding addObserver:self forKeyPath:@"foreignSpiesUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.securityBuilding.foreignSpies) {
		[self.securityBuilding loadForeignSpiesForPage:1];
	} else {
		if (self.foreignSpiesLastUpdated) {
			if ([self.foreignSpiesLastUpdated compare:self.securityBuilding.foreignSpiesUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.foreignSpiesLastUpdated = self.securityBuilding.foreignSpiesUpdated;
			}
		} else {
			self.foreignSpiesLastUpdated = self.securityBuilding.foreignSpiesUpdated;
		}
	}

	[self togglePageButtons];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.securityBuilding removeObserver:self forKeyPath:@"foreignSpiesUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.securityBuilding && self.securityBuilding.foreignSpies) {
		if ([self.securityBuilding.foreignSpies count] > 0) {
			return [self.securityBuilding.foreignSpies count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.securityBuilding && self.securityBuilding.foreignSpies) {
		if ([self.securityBuilding.foreignSpies count] > 0) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.securityBuilding && self.securityBuilding.foreignSpies) {
		if ([self.securityBuilding.foreignSpies count] > 0) {
			switch (indexPath.row) {
				case ROW_NAME:
				case ROW_LEVEL:
				case ROW_NEXT_MISSION:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				default:
					return tableView.rowHeight;
					break;
			}
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
	
	if (self.securityBuilding && self.securityBuilding.foreignSpies) {
		if ([self.securityBuilding.foreignSpies count] > 0) {
			NSDictionary *foreignSpy = [self.securityBuilding.foreignSpies objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_NAME:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *nameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					nameCell.label.text = @"Name";
					nameCell.content.text = [foreignSpy objectForKey:@"name"];
					cell = nameCell;
					break;
				case ROW_LEVEL:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *levelCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					levelCell.label.text = @"level";
					levelCell.content.text = [NSString stringWithFormat:@"%@", [foreignSpy objectForKey:@"name"]];
					cell = levelCell;
					break;
				case ROW_NEXT_MISSION:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *nextMissionCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					nextMissionCell.label.text = @"Next Mission";
					nextMissionCell.content.text = [Util formatDate:[foreignSpy objectForKey:@"next_mission"]];
					cell = nextMissionCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Foreign Spies";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Foreign Spies";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.pageSegmentedControl = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.pageSegmentedControl = nil;
	self.securityBuilding = nil;
	self.foreignSpiesLastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.securityBuilding loadForeignSpiesForPage:(self.securityBuilding.foreignSpyPageNumber-1)];
			break;
		case 1:
			[self.securityBuilding loadForeignSpiesForPage:(self.securityBuilding.foreignSpyPageNumber+1)];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.securityBuilding hasPreviousForeignSpyPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.securityBuilding hasNextForeignSpyPage] forSegmentAtIndex:1];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewForeignSpiesController *)create {
	return [[[ViewForeignSpiesController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"foreignSpiesUpdated"]) {
		[self togglePageButtons];
		[self.tableView reloadData];
		self.foreignSpiesLastUpdated = self.securityBuilding.foreignSpiesUpdated;
	}
}


@end

