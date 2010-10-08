//
//  ViewMedalsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMedalsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellMedal.h"
#import "LETableViewCellLabeledSwitch.h"
#import "LETableViewCellLabeledText.h"
#import "LEEmpireEditProfile.h"


typedef enum {
	ROW_MEDAL_INFO,
	ROW_PUBLIC_SWITCH
} ROW;


@implementation ViewMedalsController


@synthesize medals;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Medals";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.medals && [self.medals count] > 0) {
		return [self.medals count];
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.medals && [self.medals count] > 0) {
		return 2;
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.medals && [self.medals count] > 0) {
		switch (indexPath.row) {
			case ROW_MEDAL_INFO:
				; //DO NOT REMOVE
				NSDictionary *medalData = [self.medals objectAtIndex:indexPath.section];
				return [LETableViewCellMedal getHeightForTableView:tableView withMedal:medalData];
				break;
			case ROW_PUBLIC_SWITCH:
				return [LETableViewCellLabeledSwitch getHeightForTableView:tableView];
				break;
			default:
				return tableView.rowHeight;
				break;
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	if (self.medals && [self.medals count] > 0) {
		NSDictionary *medalData = [self.medals objectAtIndex:indexPath.section];
		switch (indexPath.row) {
			case ROW_MEDAL_INFO:
				; //DO NOT REMOVE
				LETableViewCellMedal *medalInfoCell = [LETableViewCellMedal getCellForTableView:tableView];
				[medalInfoCell setData:medalData];
				cell = medalInfoCell;
				break;
			case ROW_PUBLIC_SWITCH:
				; //DO NOT REMOVE
				LETableViewCellLabeledSwitch *publicSwitchCell = [LETableViewCellLabeledSwitch getCellForTableView:tableView];
				publicSwitchCell.label.text = @"Show publicly?";
				publicSwitchCell.isSelected = _boolv([medalData objectForKey:@"public"]);
				publicSwitchCell.delegate = self;
				cell = publicSwitchCell;
				break;
			default:
				break;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Medals";
		loadingCell.content.text = @"None";
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
	self.medals = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark LETableViewCellLabeledSwitchDelegate Methods

- (void)cell:(LETableViewCellLabeledSwitch *)cell switchedTo:(BOOL)isOn {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	if (indexPath) {
		NSMutableDictionary *medalData = [self.medals objectAtIndex:indexPath.section];
		if (isOn) {
			[medalData setObject:@"1" forKey:@"public"];
		} else {
			[medalData setObject:@"0" forKey:@"public"];
		}
	}
	[[[LEEmpireEditProfile alloc] initWithCallback:@selector(medalsUpdated:) target:self medals:self.medals] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)medalsUpdated:(LEEmpireEditProfile *)request {
	NSLog(@"Medals Updated", request);
	return nil;
}

#pragma mark -
#pragma mark Class Methods

+ (ViewMedalsController *)create {
	return [[[ViewMedalsController alloc] init] autorelease];
}


@end

