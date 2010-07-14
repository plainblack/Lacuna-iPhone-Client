//
//  ViewPrisonersController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewPrisonersController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "Util.h"
#import "Security.h"
#import "Prisoner.h"


typedef enum {
	ROW_PRISONER_NAME,
	ROW_PRISONER_SENTENCE
} ROW;


@implementation ViewPrisonersController


@synthesize securityBuilding;
@synthesize prisonersLastUpdated;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Prisoners";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.securityBuilding addObserver:self forKeyPath:@"prisonersUpdated" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.securityBuilding.prisoners) {
		[self.securityBuilding loadPrisoners];
	} else {
		if (self.prisonersLastUpdated) {
			if ([self.prisonersLastUpdated compare:self.securityBuilding.prisonersUpdated] == NSOrderedAscending) {
				[self.tableView reloadData];
				self.prisonersLastUpdated = self.securityBuilding.prisonersUpdated;
			}
		} else {
			self.prisonersLastUpdated = self.securityBuilding.prisonersUpdated;
		}
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.securityBuilding removeObserver:self forKeyPath:@"prisonersUpdated"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.securityBuilding && self.securityBuilding.prisoners) {
		return [self.securityBuilding.prisoners count];
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_PRISONER_NAME:
		case ROW_PRISONER_SENTENCE:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			return tableView.rowHeight;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Prisoner *prisoner = [self.securityBuilding.prisoners objectAtIndex:indexPath.section];
    
    UITableViewCell *cell;
	
	switch (indexPath.row) {
		case ROW_PRISONER_NAME:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *prisonerNameCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			prisonerNameCell.label.text = @"Name";
			prisonerNameCell.content.text = prisoner.name;
			cell = prisonerNameCell;
			break;
		case ROW_PRISONER_SENTENCE:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *prisonerSentenceCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			prisonerSentenceCell.label.text = @"Expires";
			prisonerSentenceCell.content.text = [Util formatDate:prisoner.sentenceExpiresOn];
			cell = prisonerSentenceCell;
			break;
		default:
			cell = nil;
			break;
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.securityBuilding = nil;
	self.prisonersLastUpdated = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewPrisonersController *)create {
	return [[[ViewPrisonersController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"prisonersUpdated"]) {
		[self.tableView reloadData];
		self.prisonersLastUpdated = self.securityBuilding.prisonersUpdated;
	}
}


@end

