//
//  ViewEmpireController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewEmpireController.h"
#import "LEEmpireViewProfile.h"
#import "LEViewSectionTab.h"
#import "LEMacros.h"
#import "Session.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LETableViewCellMedal.h"
#import "Util.h"


typedef enum {
	SECTION_EMPIRE,
	SECTION_MEDALS
} SECTION;


typedef enum {
	EMPIRE_ROW_NAME,
	EMPIRE_ROW_DESCRIPTION,
	EMPIRE_ROW_STATUS,
	EMPIRE_ROW_HAPPINESS,
	EMPIRE_ROW_ESSENTIA
} EMPIRE_ROW;


@implementation ViewEmpireController


@synthesize leEmpireViewProfile;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
	self.navigationItem.title = @"Loading";
	
	self.sectionHeaders = array_([LEViewSectionTab tableView:self.tableView createWithText:@"Empire"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Medals"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	Session *session = [Session sharedInstance];
	self.leEmpireViewProfile = [[[LEEmpireViewProfile alloc] initWithCallback:@selector(profileLoaded:) target:self sessionId:session.sessionId] autorelease];
}

- (void)viewDidDisappear:(BOOL)animated {
	[self.leEmpireViewProfile cancel];
	self.leEmpireViewProfile = nil;
	[super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.leEmpireViewProfile.response) {
		return 2;
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_EMPIRE:
			return 5;
			break;
		case SECTION_MEDALS:
			return [self.leEmpireViewProfile.medals count];
			break;
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;

	Session *session = [Session sharedInstance];
	switch (indexPath.section) {
		case SECTION_EMPIRE:
			switch (indexPath.row) {
				case EMPIRE_ROW_NAME:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *empireNameCell = [LETableViewCellLabeledText getCellForTableView:tableView];
					empireNameCell.label.text = @"Empire";
					empireNameCell.content.text = [session.empireData objectForKey:@"name"];
					cell = empireNameCell;
					break;
				case EMPIRE_ROW_DESCRIPTION:
					; //DO NOT REMOVE
					LETableViewCellLabeledParagraph *descriptionCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
					descriptionCell.label.text = @"Description";
					descriptionCell.content.text = leEmpireViewProfile.description;
					cell = descriptionCell;
					break;
				case EMPIRE_ROW_STATUS:
					; //DO NOT REMOVE
					LETableViewCellLabeledParagraph *statusCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
					statusCell.label.text = @"Status";
					statusCell.content.text = leEmpireViewProfile.status;
					cell = statusCell;
					break;
				case EMPIRE_ROW_HAPPINESS:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *happinessCell = [LETableViewCellLabeledText getCellForTableView:tableView];
					happinessCell.label.text = @"Happiness";
					happinessCell.content.text = [NSString stringWithFormat:@"%@", [session.empireData objectForKey:@"happiness"]];
					cell = happinessCell;
					break;
				case EMPIRE_ROW_ESSENTIA:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *essentiaCell = [LETableViewCellLabeledText getCellForTableView:tableView];
					essentiaCell.label.text = @"Essentia";
					essentiaCell.content.text = [NSString stringWithFormat:@"%@", [session.empireData objectForKey:@"essentia"]];
					cell = essentiaCell;
					break;
				default:
					break;
			}
			break;
		case SECTION_MEDALS:
			; //DO NOT REMOVE
			NSDictionary *medal = [self.leEmpireViewProfile.medals objectAtIndex:indexPath.row];
			LETableViewCellMedal *medalCell = [LETableViewCellMedal getCellForTableView:tableView];
			medalCell.medalNameLabel.text = [medal objectForKey:@"name"];
			medalCell.dateLabel.text = [Util prettyDate:[medal objectForKey:@"date"]];
			if ([medal objectForKey:@"note"] == [NSNull null]) {
				medalCell.noteView.text = @"";
			} else {
				medalCell.noteView.text = [medal objectForKey:@"note"];
			}
			medalCell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"assets/medal/%@.png", [medal objectForKey:@"image"]]];
			cell = medalCell;
			break;
		default:
			cell = nil;
			break;
	}
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_EMPIRE:
			switch (indexPath.row) {
				case EMPIRE_ROW_NAME:
				case EMPIRE_ROW_HAPPINESS:
				case EMPIRE_ROW_ESSENTIA:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case EMPIRE_ROW_DESCRIPTION:
					return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:leEmpireViewProfile.description];
					break;
				case EMPIRE_ROW_STATUS:
					return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:leEmpireViewProfile.status];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		case SECTION_MEDALS:
			; //DO NOT REMOVE
			NSDictionary *medal = [self.leEmpireViewProfile.medals objectAtIndex:indexPath.row];
			return [LETableViewCellMedal getHeightForTableView:tableView withMedal:medal];
		default:
			return 0.0;
			break;
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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
	[self.leEmpireViewProfile cancel];
	self.leEmpireViewProfile = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Callbacks

- (id)profileLoaded:(LEEmpireViewProfile *)request {
	self.navigationItem.title = @"Your profile";
	[self.tableView reloadData];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewEmpireController *) create {
	NSLog(@"create");
	return [[[ViewEmpireController alloc] init] autorelease];
}


@end

