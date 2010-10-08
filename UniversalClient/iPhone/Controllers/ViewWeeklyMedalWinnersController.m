//
//  ViewWeeklyMedalWinnersController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewWeeklyMedalWinnersController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEStatsWeeklyMedalWinners.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellMedalWinnerMedal.h"


typedef enum {
	ROW_MEDAL,
	ROW_EMPIRE,
	ROW_TIMES_EARNED,
} ROW;


@implementation ViewWeeklyMedalWinnersController


@synthesize winners;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Medal Winners";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[[LEStatsWeeklyMedalWinners alloc] initWithCallback:@selector(winnersLoaded:) target:self] autorelease];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.winners) {
		if ([self.winners count] > 0) {
			return [self.winners count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.winners) {
		if ([self.winners count] > 0) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.winners) {
		if ([self.winners count] > 0) {
			switch (indexPath.row) {
				case ROW_EMPIRE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_MEDAL:
					return [LETableViewCellMedalWinnerMedal getHeightForTableView:tableView];
					break;
				case ROW_TIMES_EARNED:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
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
	
	if (self.winners) {
		if ([self.winners count] > 0) {
			NSMutableDictionary *winner = [self.winners objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_EMPIRE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *empireCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					empireCell.label.text = @"Empire";
					empireCell.content.text = [winner objectForKey:@"empire_name"];
					cell = empireCell;
					break;
				case ROW_MEDAL:
					; //DO NOT REMOVE
					LETableViewCellMedalWinnerMedal *medalCell = [LETableViewCellMedalWinnerMedal getCellForTableView:tableView];
					[medalCell setData:winner];
					cell = medalCell;
					break;
				case ROW_TIMES_EARNED:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *timesEarnedCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					timesEarnedCell.label.text = @"Times earned";
					timesEarnedCell.content.text = [winner objectForKey:@"times_earned"];
					cell = timesEarnedCell;
					break;
				default:
					cell = nil;
					break;
			}
			
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Winners";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Winners";
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
	[super viewDidUnload];
}


- (void)dealloc {
	self.winners = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (id)winnersLoaded:(LEStatsWeeklyMedalWinners *)request {
	self.winners = request.winners;
	[self.tableView reloadData];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewWeeklyMedalWinnersController *)create {
	return [[[ViewWeeklyMedalWinnersController alloc] init] autorelease];
}


@end

