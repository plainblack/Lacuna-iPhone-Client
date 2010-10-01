//
//  SelectEmpireSpeciesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectSpeciesTemplateController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LEEmpireGetSpeciesTemplates.h"
#import "NewSpeciesController.h"


@implementation SelectSpeciesTemplateController


@synthesize empireId;
@synthesize username;
@synthesize password;
@synthesize templates;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Select Species";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Species Template"]);
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (!self.templates) {
		[[[LEEmpireGetSpeciesTemplates alloc] initWithCallback:@selector(speciesTemplatesLoaded:) target:self] autorelease];
	}
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
	return MAX([self.templates count], 1);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.templates count] > 0) {
		return [LETableViewCellButton getHeightForTableView:tableView];
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	if (self.templates) {
		if ([self.templates count] > 0) {
			NSMutableDictionary *template = [self.templates objectAtIndex:indexPath.row];
			LETableViewCellButton *templateCell = [LETableViewCellButton getCellForTableView:tableView];
			templateCell.textLabel.text = [template objectForKey:@"name"];
			cell = templateCell;
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Templates";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Templates";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.templates) {
		if ([self.templates count] > 0) {
			NSMutableDictionary *template = [self.templates objectAtIndex:indexPath.row];
			NewSpeciesController *newSpeciesController = [NewSpeciesController create];
			newSpeciesController.empireId = self.empireId;
			newSpeciesController.username = self.username;
			newSpeciesController.password = self.password;
			newSpeciesController.speciesTemplate = template;
			[self.navigationController pushViewController:newSpeciesController animated:YES];
		}
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
	self.templates = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.templates = nil;
	self.empireId = nil;
	self.username = nil;
	self.password = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)cancel {
	[self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Callback Methods

- (id)speciesTemplatesLoaded:(LEEmpireGetSpeciesTemplates *)request {
	if (![request wasError]) {
		self.templates = request.templates;
		[self.tableView reloadData];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (SelectSpeciesTemplateController *)create {
	return [[[SelectSpeciesTemplateController alloc] init] autorelease];
}


@end

