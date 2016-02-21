//
//  ViewBattleLogsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/7/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ViewBattleLogsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "SpacePort.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellParagraph.h"
#import "LETableViewCellBattleReport.h"


@interface ViewBattleLogsController (PrivateMethods)

- (void)togglePageButtons;

@end


@implementation ViewBattleLogsController


@synthesize pageSegmentedControl;
@synthesize spacePort;
@synthesize lastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Battle Logs";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.spacePort addObserver:self forKeyPath:@"battleLogsUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.spacePort.battleLogs) {
		[self.spacePort loadBattleLogsForPage:[NSDecimalNumber one]];
	} else {
		if (self.lastUpdated) {
			if ([self.lastUpdated compare:self.spacePort.battleLogsUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.lastUpdated = self.spacePort.battleLogsUpdated;
			}
		} else {
			self.lastUpdated = self.spacePort.battleLogsUpdated;
		}
	}
	
	[self togglePageButtons];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.spacePort removeObserver:self forKeyPath:@"battleLogsUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MAX(1, [self.spacePort.battleLogs count]);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.spacePort && self.spacePort.battleLogs) {
		if ([self.spacePort.battleLogs count] > 0) {
            return [LETableViewCellBattleReport getHeightForTableView:tableView];
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
	
	if (self.spacePort && self.spacePort.battleLogs) {
		if ([self.spacePort.battleLogs count] > 0) {
			NSMutableDictionary *battleLog = [self.spacePort.battleLogs objectAtIndex:indexPath.row];
			LETableViewCellBattleReport *battleLogCell = [LETableViewCellBattleReport getCellForTableView:tableView];
            [battleLogCell setBattleLog:battleLog];
			cell = battleLogCell;
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"In Orbit";
			loadingCell.content.text = @"None";
			cell = loadingCell;
		}
		
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"In Orbit";
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
	self.spacePort = nil;
	self.lastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.spacePort loadBattleLogsForPage:[Util decimalFromInt:(_intv(self.spacePort.battleLogPageNumber) - 1)]];
			break;
		case 1:
			[self.spacePort loadBattleLogsForPage:[Util decimalFromInt:(_intv(self.spacePort.battleLogPageNumber) + 1)]];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


#pragma mark -
#pragma mark Private Methods

- (void)togglePageButtons {
	[self.pageSegmentedControl setEnabled:[self.spacePort hasPreviousBattleLogPage] forSegmentAtIndex:0];
	[self.pageSegmentedControl setEnabled:[self.spacePort hasNextBattleLogPage] forSegmentAtIndex:1];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewBattleLogsController *)create {
	return [[[ViewBattleLogsController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"battleLogsUpdated"]) {
		[self togglePageButtons];
		[self.tableView reloadData];
		self.lastUpdated = self.spacePort.battleLogsUpdated;
	}
}


@end
