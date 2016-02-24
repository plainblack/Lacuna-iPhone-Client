//
//  ViewSpiesForTrainingController.m
//  UniversalClient
//
//  Created by Kevin Runde on 5/30/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ViewSpiesForTrainingController.h"
#import "LEMacros.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "RenameSpyController.h"
#import "AssignSpyController.h"
#import "LETableViewCellSpyInfo.h"
#import "Util.h"
#import "SpyTraining.h"
#import "Spy.h"
#import "LEBuildingTrainSpySkill.h"


typedef enum {
	ROW_SPY_INFO,
	ROW_TRAIN_BUTTON,
	ROW_COUNT
} ROW;


@implementation ViewSpiesForTrainingController


@synthesize spyTraining;
@synthesize selectedSpy;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"Available Spies";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
	if (self.spyTraining && self.spyTraining.spies) {
		return [self.spyTraining.spies count];
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return ROW_COUNT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case ROW_TRAIN_BUTTON:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return tableView.rowHeight;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *spy = [self.spyTraining.spies objectAtIndex:indexPath.section];
	
	UITableViewCell *cell = nil;
	
	switch (indexPath.row) {
		case ROW_SPY_INFO:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *spyInfoCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			spyInfoCell.label.text = @"Name";
			spyInfoCell.content.text = [spy objectForKey:@"name"];
			cell = spyInfoCell;
			break;
		case ROW_TRAIN_BUTTON:
			; //DO NOT REMOVE
			LETableViewCellButton *trainButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			trainButtonCell.textLabel.text = @"Train";
			cell = trainButtonCell;
			break;
		default:
			cell = nil;
			break;
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableDictionary *spy = [self.spyTraining.spies objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_TRAIN_BUTTON:
			[self.spyTraining trainSpy:[Util idFromDict:spy named:@"spy_id"] target:self callback:@selector(trainedSpy:)];
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
	self.spyTraining = nil;
	self.selectedSpy = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)trainedSpy:(LEBuildingTrainSpySkill *)request {
	NSMutableDictionary *reasonNotTrained = [request.results objectForKey:@"reason_not_trained"];
	if (isNotNull(reasonNotTrained)) {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"Your spy could not be trained. %@", [reasonNotTrained objectForKey:@"message"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
	} else {
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Training Started" message:@"Your spy is now busy training." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:[self.tableView indexPathForSelectedRow].section] withRowAnimation:UITableViewRowAnimationFade];
	}
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		self.selectedSpy = nil;
	}
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewSpiesForTrainingController *)create {
	return [[[ViewSpiesForTrainingController alloc] init] autorelease];
}


@end
