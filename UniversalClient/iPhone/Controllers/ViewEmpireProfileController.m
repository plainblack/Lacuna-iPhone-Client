//
//  ViewEmpireController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewEmpireProfileController.h"
#import "LEEmpireViewProfile.h"
#import "LEViewSectionTab.h"
#import "LEMacros.h"
#import "Session.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LETableViewCellMedal.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "ViewEmpireBoostsController.h"
#import "EditEmpireProfileText.h"


typedef enum {
	SECTION_EMPIRE,
	SECTION_MEDALS
} SECTION;


typedef enum {
	EMPIRE_ROW_NAME,
	EMPIRE_ROW_DESCRIPTION,
	EMPIRE_ROW_STATUS,
	EMPIRE_ROW_ESSENTIA,
	EMPIRE_ROW_BOOSTS
} EMPIRE_ROW;


@implementation ViewEmpireProfileController


@synthesize leEmpireViewProfile;
@synthesize empireProfile;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
	self.navigationItem.title = @"Loading";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Empire"],
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
			return [empireProfile.medals count];
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_EMPIRE:
			switch (indexPath.row) {
				case EMPIRE_ROW_NAME:
				case EMPIRE_ROW_ESSENTIA:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case EMPIRE_ROW_DESCRIPTION:
					return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:self.empireProfile.description];
					break;
				case EMPIRE_ROW_STATUS:
					return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:self.empireProfile.status];
					break;
				case EMPIRE_ROW_BOOSTS:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		case SECTION_MEDALS:
			; //DO NOT REMOVE
			NSDictionary *medal = [empireProfile.medals objectAtIndex:indexPath.row];
			return [LETableViewCellMedal getHeightForTableView:tableView withMedal:medal];
		default:
			return 0.0;
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
					LETableViewCellLabeledText *empireNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					empireNameCell.label.text = @"Empire";
					empireNameCell.content.text = session.empire.name;
					cell = empireNameCell;
					break;
				case EMPIRE_ROW_DESCRIPTION:
					; //DO NOT REMOVE
					LETableViewCellLabeledParagraph *descriptionCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
					descriptionCell.label.text = @"Description";
					if ((id)self.empireProfile.description == [NSNull null]) {
						descriptionCell.content.text = @"";
					} else {
						descriptionCell.content.text = self.empireProfile.description;
					}
					descriptionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					descriptionCell.selectionStyle = UITableViewCellSelectionStyleBlue;
					cell = descriptionCell;
					break;
				case EMPIRE_ROW_STATUS:
					; //DO NOT REMOVE
					LETableViewCellLabeledParagraph *statusCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
					statusCell.label.text = @"Status";
					statusCell.content.text = self.empireProfile.status;
					statusCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					statusCell.selectionStyle = UITableViewCellSelectionStyleBlue;
					cell = statusCell;
					break;
				case EMPIRE_ROW_ESSENTIA:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *essentiaCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					essentiaCell.label.text = @"Essentia";
					essentiaCell.content.text = [NSString stringWithFormat:@"%@", session.empire.essentia];
					cell = essentiaCell;
					break;
				case EMPIRE_ROW_BOOSTS:
					; //DO NOT REMOVE
					LETableViewCellButton *boostsButton = [LETableViewCellButton getCellForTableView:tableView];
					boostsButton.textLabel.text = @"View Empire Boosts";
					cell = boostsButton;
					break;
				default:
					break;
			}
			break;
		case SECTION_MEDALS:
			; //DO NOT REMOVE
			NSDictionary *medal = [empireProfile.medals objectAtIndex:indexPath.row];
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case EMPIRE_ROW_BOOSTS:
			; //DO NOT REMOVE
			ViewEmpireBoostsController *viewEmpireBoostsController = [ViewEmpireBoostsController create];
			[self.navigationController pushViewController:viewEmpireBoostsController animated:YES];
			break;
		case EMPIRE_ROW_DESCRIPTION:
			; //DO NOT REMOVE
			NSLog(@"");
			EditEmpireProfileText *editDescriptionEmpireProfileText = [EditEmpireProfileText createForEmpireProfile:self.empireProfile textName:@"Description" textKey:@"description" text:self.empireProfile.description];
			[self.navigationController pushViewController:editDescriptionEmpireProfileText animated:YES];
			break;
		case EMPIRE_ROW_STATUS:
			; //DO NOT REMOVE
			EditEmpireProfileText *editStatusEmpireProfileText = [EditEmpireProfileText createForEmpireProfile:self.empireProfile textName:@"Status" textKey:@"status_message" text:self.empireProfile.status];
			[self.navigationController pushViewController:editStatusEmpireProfileText animated:YES];
			break;
		default:
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
	[self.leEmpireViewProfile cancel];
	self.leEmpireViewProfile = nil;
	self.empireProfile = nil;
	[super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Callbacks

- (id)profileLoaded:(LEEmpireViewProfile *)request {
	self.navigationItem.title = @"Empire Profile";
	self.empireProfile = request.empire;
	[self.tableView reloadData];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewEmpireProfileController *) create {
	return [[[ViewEmpireProfileController alloc] init] autorelease];
}


@end

