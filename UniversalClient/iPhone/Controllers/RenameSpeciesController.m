//
//  RenameSpeciesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/7/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "RenameSpeciesController.h"
#import "LEMacros.h"
#import "Session.h"
#import "GeneticsLab.h"
#import "LEBuildingRenameSpecies.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LEEmpireViewSpeciesStats.h"
#import "LETableViewCellLabeledText.h"


typedef enum {
	RENAME_SPECIES_ROW_NAME,
	RENAME_SPECIES_ROW_DESCRIPTION,
    RENAME_SPECIES_ROW_COUNT
} RENAME_SPECIES_ROW;


@implementation RenameSpeciesController


@synthesize geneticsLab;
@synthesize nameCell;
@synthesize descriptionCell;
@synthesize speciesStats;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Rename Species";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	
	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.nameCell.delegate = self;
	self.nameCell.label.text = @"Name";
	self.nameCell.textField.text = @"";
    
    self.descriptionCell = [LETableViewCellTextView getCellForTableView:self.tableView];
    self.descriptionCell.textView.text = @"";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Rename Species"]);
    
    if (isNull(self.speciesStats)) {
        [[[LEEmpireViewSpeciesStats alloc] initWithCallback:@selector(loadedSpeciesStats:) target:self] autorelease];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.nameCell becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isNull(self.speciesStats)) {
        return 1;
    } else {
        return RENAME_SPECIES_ROW_COUNT;
    }
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isNull(self.speciesStats)) {
        return [LETableViewCellLabeledText getHeightForTableView:tableView];
    } else {
        switch (indexPath.row) {
            case RENAME_SPECIES_ROW_NAME:
                return [LETableViewCellTextEntry getHeightForTableView:tableView];
                break;
            case RENAME_SPECIES_ROW_DESCRIPTION:
                return [LETableViewCellTextView getHeightForTableView:tableView];
                break;
            default:
                return 0.0;
                break;
        }
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isNull(self.speciesStats)) {
        LETableViewCellLabeledText *cell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
        cell.label.text = @"Species";
        cell.content.text = @"Loading";
        return cell;
    } else {
        switch (indexPath.row) {
            case RENAME_SPECIES_ROW_NAME:
                return self.nameCell;
                break;
            case RENAME_SPECIES_ROW_DESCRIPTION:
                return self.descriptionCell;
                break;
            default:
                return nil;
                break;
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.geneticsLab = nil;
	self.nameCell = nil;
    self.speciesStats = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sue you wish to do this?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
		[self.geneticsLab changeName:self.nameCell.textField.text description:self.descriptionCell.textView.text forTarger:self callback:@selector(speciesRenamed:)];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
	}];
	[alert addAction:cancelAction];
	[alert addAction:okAction];
	[self presentViewController:alert animated:YES completion:nil];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.nameCell.textField) {
		[self.nameCell resignFirstResponder];
		[self save];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Callback Methods

- (void)speciesRenamed:(LEBuildingRenameSpecies *)request {
	if (![request wasError]) {
		[[self navigationController] popViewControllerAnimated:YES];
	}
}

- (void)loadedSpeciesStats:(LEEmpireViewSpeciesStats *)request {
    self.speciesStats = request.stats;
    NSLog(@"Species: %@", self.speciesStats);
    self.nameCell.textField.text = [self.speciesStats objectForKey:@"name"];
    self.descriptionCell.textView.text = [self.speciesStats objectForKey:@"description"];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (RenameSpeciesController *)create {
	return [[[RenameSpeciesController alloc] init] autorelease];
}


@end
