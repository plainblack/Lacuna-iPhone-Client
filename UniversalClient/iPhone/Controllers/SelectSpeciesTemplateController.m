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
#import "LETableViewCellParagraph.h"
#import "LEEmpireGetSpeciesTemplates.h"
#import "NewSpeciesController.h"


typedef enum {
	ROW_SPECIES_DESCRIPTION,
	ROW_SELECT_SPECIES
} ROW;


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
	
	self.sectionHeaders = [NSArray array];//_array([LEViewSectionTab tableView:self.tableView withText:@"Species Template"]);
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
	return MAX([self.templates count], 1);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.templates count] > 0) {
		NSDictionary *speciesTemplate = [self.templates objectAtIndex:indexPath.section];
		NSLog(@"speciesTemplate: %@", speciesTemplate);
		switch (indexPath.row) {
			case ROW_SPECIES_DESCRIPTION:
				return [LETableViewCellParagraph getHeightForTableView:tableView text:[speciesTemplate objectForKey:@"description"]];
				break;
			case ROW_SELECT_SPECIES:
				return [LETableViewCellButton getHeightForTableView:tableView];
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
	
	if (self.templates) {
		if ([self.templates count] > 0) {
			NSDictionary *speciesTemplate = [self.templates objectAtIndex:indexPath.section];
			NSLog(@"speciesTemplate: %@", speciesTemplate);
			switch (indexPath.row) {
				case ROW_SPECIES_DESCRIPTION:
					; //DO NOT REMOVE
					LETableViewCellParagraph *descritionCell = [LETableViewCellParagraph getCellForTableView:tableView];
					descritionCell.content.text = [speciesTemplate objectForKey:@"description"];
					cell = descritionCell;
					break;
				case ROW_SELECT_SPECIES:
					; //DO NOT REMOVE
					LETableViewCellButton *templateCell = [LETableViewCellButton getCellForTableView:tableView];
					templateCell.textLabel.text = @"Select";
					cell = templateCell;
					break;
				default:
					break;
			}
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
			NSMutableDictionary *speciesTemplate = [self.templates objectAtIndex:indexPath.section];
			NSLog(@"speciesTemplate: %@", speciesTemplate);
			switch (indexPath.row) {
				case ROW_SELECT_SPECIES:
					; //DO NOT REMOVE
					NewSpeciesController *newSpeciesController = [NewSpeciesController create];
					newSpeciesController.empireId = self.empireId;
					newSpeciesController.username = self.username;
					newSpeciesController.password = self.password;
					newSpeciesController.speciesTemplate = speciesTemplate;
					[self.navigationController pushViewController:newSpeciesController animated:YES];
					break;
			}
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
		NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[request.templates count]];
		[request.templates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
			[tmp addObject:[LEViewSectionTab tableView:self.tableView withText:[obj objectForKey:@"name"]]];
		}];
		self.sectionHeaders = tmp;
		NSLog(@"sectionHeaders: %@", self.sectionHeaders);
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

