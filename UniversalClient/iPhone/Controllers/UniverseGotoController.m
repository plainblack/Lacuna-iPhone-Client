//
//  UniverseGotoController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "UniverseGotoController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Star.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextEntry.h"
#import "LEBodyStatus.h"
#import "LEMapSearchStars.h"


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
	UITableViewCell *cell = nil;
	
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
					Star *star = [self.stars objectAtIndex:indexPath.row];
					LETableViewCellButton *empireButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					empireButtonCell.textLabel.text = star.name;
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
		[[[LEBodyStatus alloc] initWithCallback:@selector(bodyLoaded:) target:self bodyId:[planet objectForKey:@"id"]] autorelease];
	} else if (indexPath.section == SECTION_STARS) {
		Star *star = [self.stars objectAtIndex:indexPath.row];
		[self.delegate selectedGridX:star.x gridY:star.y];
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
	[[[LEMapSearchStars alloc] initWithCallback:@selector(starsFound:) target:self name:starName] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)bodyLoaded:(LEBodyStatus *)request {
	[self.delegate selectedGridX:[Util asNumber:[request.body objectForKey:@"x"]] gridY:[Util asNumber:[request.body objectForKey:@"y"]]];
	return nil;
}


- (void)starsFound:(LEMapSearchStars *)request {
	NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[request.stars count]];
	for (NSMutableDictionary *starData in request.stars) {
		Star *star = [[Star alloc] init];
		[star parseData:starData];
		[tmp addObject:star];
		[star release];
	}
	self.stars = tmp;
	[self.tableView reloadData];
}




#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([textField.text length] > 2) {
		[self searchForStar:textField.text];
		return YES;
	} else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message: @"You must enter at least 3 characters to search." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		return NO;
	}
}


#pragma mark -
#pragma mark Class Methods

+ (UniverseGotoController *)create {
	return [[[UniverseGotoController alloc] init] autorelease];
}


@end

