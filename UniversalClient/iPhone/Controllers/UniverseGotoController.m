//
//  UniverseGotoController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "UniverseGotoController.h"
#import "LEMacros.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextEntry.h"
//#import "LEMapGetStar.h"
//#import "LEMapSearchStars.h"


typedef enum {
	SECTION_MY_WORLDS,
	SECTION_SEARCH,
	SECTION_STARS
} SECTION;


@implementation UniverseGotoController


@synthesize stars;
@synthesize delegate;
@synthesize starNameCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Search For Empire";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"My Worlds"], [LEViewSectionTab tableView:self.tableView withText:@"Search"], [LEViewSectionTab tableView:self.tableView withText:@"Matches"]);
	
	self.starNameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	[self.starNameCell setReturnKeyType:UIReturnKeySearch];
	self.starNameCell.delegate = self;
	self.starNameCell.label.text = @"Star Name";
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_MY_WORLDS:
			; //DO NOT REMOVE
			Session *session = [Session sharedInstance];
			return [session.empire.planets count];
			break;
		case SECTION_SEARCH:
			return 1;
			break;
		case SECTION_STARS:
			if (self.stars && [self.stars count] > 0) {
				return [self.stars count];
			} else {
				return 1;
			}
			break;
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_MY_WORLDS:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case SECTION_SEARCH:
			return [LETableViewCellTextEntry getHeightForTableView:tableView];
			break;
		case SECTION_STARS:
			if (self.stars && [self.stars count] > 0) {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			} else {
				return [LETableViewCellButton getHeightForTableView:tableView];
			}
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case SECTION_MY_WORLDS:
			; //DO NOT REMOVE
			Session *session = [Session sharedInstance];
			NSDictionary *planet = [session.empire.planets objectAtIndex:indexPath.row];
			LETableViewCellButton *myWorldCell = [LETableViewCellButton getCellForTableView:tableView];
			myWorldCell.textLabel.text = [planet objectForKey:@"name"];
			cell = myWorldCell;
			break;
		case SECTION_SEARCH:
			cell = self.starNameCell;
			break;
		case SECTION_STARS:
			if (self.stars) {
				if ([self.stars count] > 0) {
					NSDictionary *star = [self.stars objectAtIndex:indexPath.row];
					LETableViewCellButton *empireButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					empireButtonCell.textLabel.text = [star objectForKey:@"name"];
					cell = empireButtonCell;
				} else {
					LETableViewCellLabeledText *noMatchesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					noMatchesCell.content.text = @"No Matches";
					cell = noMatchesCell;
				}
				
			} else {
				LETableViewCellLabeledText *searchCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				searchCell.content.text = @"Enter a name";
				cell = searchCell;
			}
			break;
		default:
			cell = nil;
			break;
	}
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == SECTION_MY_WORLDS) {
		Session *session = [Session sharedInstance];
		NSDictionary *planet = [session.empire.planets objectAtIndex:indexPath.row];
		NSLog(@"Selected My World: %@", planet);
	} else if (indexPath.section == SECTION_STARS) {
		NSDictionary *star = [self.stars objectAtIndex:indexPath.row];
		NSLog(@"Selected Star: %@", star);
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
	self.starNameCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.starNameCell = nil;
	self.stars = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)searchForStar:(NSString *)starName {
	//[[[LEStatsFindEmpireRank alloc] initWithCallback:@selector(empiresFound:) target:self sortBy:self.sortBy empireName:empireName] autorelease];
}


/*
#pragma mark -
#pragma mark Callback Methods

- (void)empiresFound:(LEStatsFindEmpireRank *)request {
	self.empires = request.empires;
	[self.tableView reloadData];
}
*/

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField.text length] > 2) {
		[self searchForStar:textField.text];
		return YES;
	} else {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must enter at least 3 characters to search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
		return NO;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (UniverseGotoController *)create {
	return [[[UniverseGotoController alloc] init] autorelease];
}


@end

