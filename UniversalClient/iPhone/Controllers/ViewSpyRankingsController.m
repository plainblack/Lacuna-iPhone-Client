//
//  ViewSpyRankingsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/25/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewSpyRankingsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEStatsSpyRank.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"


typedef enum {
	ROW_EMPIRE,
	ROW_SPY_NAME,
	ROW_AGE,
	ROW_LEVEL,
	ROW_SUCCESS_RATE,
	ROW_DIRTIEST,
} ROW;

@implementation ViewSpyRankingsController


@synthesize sortBy;
@synthesize spies;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if ([self.sortBy isEqualToString:@"level_rank"]) {
		self.navigationItem.title = @"Spy Level";
	} else if ([self.sortBy isEqualToString:@"success_rate_rank"]) {
		self.navigationItem.title = @"Spy Success Rate";
	} else if ([self.sortBy isEqualToString:@"dirtiest_rank"]) {
		self.navigationItem.title = @"Dirtiest Spies";
	} else {
		self.navigationItem.title = @"Spies";
	}
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[[LEStatsSpyRank alloc] initWithCallback:@selector(spiesLoaded:) target:self sortBy:self.sortBy] autorelease];
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
	if (self.spies) {
		if ([self.spies count] > 0) {
			return [self.spies count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.spies) {
		if ([self.spies count] > 0) {
			return 6;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.spies) {
		if ([self.spies count] > 0) {
			switch (indexPath.row) {
				case ROW_EMPIRE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_SPY_NAME:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_AGE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_LEVEL:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_SUCCESS_RATE:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_DIRTIEST:
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
    
    UITableViewCell *cell;
	
	if (self.spies) {
		if ([self.spies count] > 0) {
			NSMutableDictionary *spy = [self.spies objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_EMPIRE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *empireCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					empireCell.label.text = @"Empire";
					empireCell.content.text = [spy objectForKey:@"empire_name"];
					cell = empireCell;
					break;
				case ROW_SPY_NAME:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *spyNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					spyNameCell.label.text = @"Spy";
					spyNameCell.content.text = [spy objectForKey:@"spy_name"];
					cell = spyNameCell;
					break;
				case ROW_AGE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *ageCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					ageCell.label.text = @"Age";
					ageCell.content.text = [NSString stringWithFormat:@"%@ seconds", [spy objectForKey:@"age"]];
					cell = ageCell;
					break;
				case ROW_LEVEL:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *levelCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					levelCell.label.text = @"Level";
					levelCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[spy objectForKey:@"level"]]];
					cell = levelCell;
					break;
				case ROW_SUCCESS_RATE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *successRateCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					successRateCell.label.text = @"Success Rate";
					successRateCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[spy objectForKey:@"success_rate"]]];
					cell = successRateCell;
					break;
				case ROW_DIRTIEST:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *dirtiestCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					dirtiestCell.label.text = @"Dirtiest";
					dirtiestCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[spy objectForKey:@"dirtiest"]]];
					cell = dirtiestCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Spies";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Spies";
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
	self.spies = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.sortBy = nil;
	self.spies = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (id)spiesLoaded:(LEStatsSpyRank *)request {
	self.spies = request.spies;
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[self.spies count]];
	for (int i=0; i < [self.spies count]; i++) {
		[tmp addObject:[LEViewSectionTab tableView:self.tableView withText:[NSString stringWithFormat:@"Spy %i", (i+1)]]];
	}
	self.sectionHeaders = tmp;
	[self.tableView reloadData];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewSpyRankingsController *)create {
	return [[[ViewSpyRankingsController alloc] init] autorelease];
}


@end

