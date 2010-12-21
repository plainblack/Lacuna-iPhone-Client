//
//  ViewAllianceController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewAllianceStashController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Embassy.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLongLabeledText.h"
#import "LEBuildingViewStash.h"
#import "LEBuildingDonateToStash.h"
#import "LEBuildingExchangeWithStash.h"
#import "BuildStashDonationController.h"
#import "BuildStashExchangeController.h"


typedef enum {
	SECTION_INFO,
	SECTION_ACTIONS,
	SECTION_STASH,
} SECTION;


typedef enum {
	INFO_ROW_EXCHANGE_SIZE,
	INFO_ROW_EXCHANGES_REMAINING,
} INFO_ROW;


typedef enum {
	ACTION_ROW_EXCHANGE,
	ACTION_ROW_DONATE,
} ACTION_ROW;


@implementation ViewAllianceStashController


@synthesize embassy;
@synthesize stashKeys;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Stash";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Loading"]);
	[self.embassy getStashTarget:self callback:@selector(loadedStash)];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.stashKeys = [self.embassy.stash keysSortedByValueUsingSelector:@selector(compare:)];
	[self.tableView reloadData];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.embassy.stash) {
		return 3;
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.embassy.stash) {
		switch (section) {
			case SECTION_INFO:
				return 2;
				break;
			case SECTION_ACTIONS:
				return 2;
				break;
			case SECTION_STASH:
				return MAX(1, [self.embassy.stash count]);
				break;
			default:
				return 0;
				break;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.embassy.stash) {
		switch (indexPath.section) {
			case SECTION_INFO:
				return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
				break;
			case SECTION_ACTIONS:
				return [LETableViewCellButton getHeightForTableView:tableView];
				break;
			case SECTION_STASH:
				return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
				break;
			default:
				return 0.0;
				break;
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if (self.embassy.stash) {
		switch (indexPath.section) {
			case SECTION_INFO:
				switch (indexPath.row) {
					case INFO_ROW_EXCHANGE_SIZE:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *exchangeSizeCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						exchangeSizeCell.label.text = @"Max Exchange Size";
						exchangeSizeCell.content.text = [Util prettyNSDecimalNumber:self.embassy.maxExchangeSize];
						cell = exchangeSizeCell;
						break;
					case INFO_ROW_EXCHANGES_REMAINING:
						; //DO NOT REMOVE
						LETableViewCellLongLabeledText *exchangesRemainingCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
						exchangesRemainingCell.label.text = @"Daily Exchanges Remaining";
						exchangesRemainingCell.content.text = [Util prettyNSDecimalNumber:self.embassy.exchangesRemainingToday];
						cell = exchangesRemainingCell;
						break;
					default:
						cell = nil;
						break;
				}
				break;
			case SECTION_ACTIONS:
				switch (indexPath.row) {
					case ACTION_ROW_DONATE:
						; //DO NOT REMOVE
						LETableViewCellButton *donateCell = [LETableViewCellButton getCellForTableView:tableView];
						donateCell.textLabel.text = @"Donate";
						cell = donateCell;
						break;
					case ACTION_ROW_EXCHANGE:
						; //DO NOT REMOVE
						LETableViewCellButton *exchangeCell = [LETableViewCellButton getCellForTableView:tableView];
						exchangeCell.textLabel.text = @"Exchange";
						cell = exchangeCell;
						break;
					default:
						cell = nil;
						break;
				}
				break;
			case SECTION_STASH:
				if ([self.embassy.stash count] > 0) {
					NSString *key = [self.stashKeys objectAtIndex:indexPath.row];
					LETableViewCellLongLabeledText *itemCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
					itemCell.label.text = [Util prettyCodeValue:key];
					itemCell.content.text = [Util prettyNSDecimalNumber:[Util asNumber:[self.embassy.stash objectForKey:key]]];
					cell = itemCell;
				} else {
					LETableViewCellLabeledText *noneCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					noneCell.label.text = @"Resources";
					noneCell.content.text = @"None";
					cell = noneCell;
				}
				break;
			default:
				cell = nil;
				break;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Resources";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
	
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_ACTIONS:
			switch (indexPath.row) {
				case ACTION_ROW_DONATE:
					; //DO NOT REMOVE
					BuildStashDonationController *buildStashDonationController = [BuildStashDonationController create];
					buildStashDonationController.embassy = self.embassy;
					[self.navigationController pushViewController:buildStashDonationController animated:YES];
					break;
				case ACTION_ROW_EXCHANGE:
					; //DO NOT REMOVE
					BuildStashExchangeController *buildStashExchangeController = [BuildStashExchangeController create];
					buildStashExchangeController.embassy = self.embassy;
					[self.navigationController pushViewController:buildStashExchangeController animated:YES];
					break;
			}
			break;
	}
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
	self.embassy = nil;
	self.stashKeys = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)loadedStash {
	self.stashKeys = [self.embassy.stash keysSortedByValueUsingSelector:@selector(compare:)];
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Exchange Details"], [LEViewSectionTab tableView:self.tableView withText:@"Actions"], [LEViewSectionTab tableView:self.tableView withText:@"Resources"]);
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewAllianceStashController *)create {
	return [[[ViewAllianceStashController alloc] init] autorelease];
}


@end

