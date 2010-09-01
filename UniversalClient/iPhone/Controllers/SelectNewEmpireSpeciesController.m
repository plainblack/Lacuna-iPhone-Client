//
//  SelectEmpireSpeciesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectNewEmpireSpeciesController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LETableViewCellParagraph.h"
#import "LETableViewCellButton.h"
#import "LESpeciesSetHuman.h"
#import "LESpeciesCreate.h"
#import "NewSpeciesController.h"
#import "FoundNewEmpireController.h"


#define SELECT_MESSAGE @"You can select to be human which is average in all affinities and can live on Orbit 3 planets or you can create a custom species so you can choose your affinities levels and habitial planets."

typedef enum {
	ROW_SELECT_MESSAGE,
	ROW_HUMAN,
	ROW_CUSTOM
} ROW;


@implementation SelectNewEmpireSpeciesController


@synthesize empireId;
@synthesize username;
@synthesize password;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Select Species";
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
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_SELECT_MESSAGE:
			return [LETableViewCellParagraph getHeightForTableView:tableView text:SELECT_MESSAGE];
			break;
		case ROW_HUMAN:
		case ROW_CUSTOM:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;

	switch (indexPath.row) {
		case ROW_SELECT_MESSAGE:
			; //DO NOT REMOVE
			LETableViewCellParagraph *selectMessageCell = [LETableViewCellParagraph getCellForTableView:tableView];
			selectMessageCell.content.text = SELECT_MESSAGE;
			cell = selectMessageCell;
			break;
		case ROW_HUMAN:
			; //DO NOT REMOVE
			LETableViewCellButton *humanSelectButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			humanSelectButtonCell.textLabel.text = @"Human";
			cell = humanSelectButtonCell;
			break;
		case ROW_CUSTOM:
			; //DO NOT REMOVE
			LETableViewCellButton *customSelectButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			customSelectButtonCell.textLabel.text = @"Custom";
			cell = customSelectButtonCell;
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
	switch (indexPath.row) {
		case ROW_HUMAN:
			[[[LESpeciesSetHuman alloc] initWithCallback:@selector(humanSet:) target:self empireId:self.empireId] autorelease];
			break;
		case ROW_CUSTOM:
			; //DO NOT REMOVE
			NewSpeciesController *newSpeciesController = [NewSpeciesController create];
			newSpeciesController.empireId = self.empireId;
			newSpeciesController.username = self.username;
			newSpeciesController.password = self.password;
			[self.navigationController pushViewController:newSpeciesController animated:YES];
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.empireId = nil;
	self.username = nil;
	self.password = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Memory management

- (id)humanSet:(LESpeciesSetHuman *)request {
	if (![request wasError]) {
		FoundNewEmpireController *foundNewEmpireController = [FoundNewEmpireController create];
		foundNewEmpireController.empireId = self.empireId;
		foundNewEmpireController.username = self.username;
		foundNewEmpireController.password = self.password;
		[self.navigationController pushViewController:foundNewEmpireController animated:YES];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (SelectNewEmpireSpeciesController *)create {
	return [[[SelectNewEmpireSpeciesController alloc] init] autorelease];
}


@end

