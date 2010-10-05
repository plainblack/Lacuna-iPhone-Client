//
//  ViewAllianceProfileController.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewAllianceProfileController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "AlliancePublicProfile.h"
#import "AllianceMember.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LEAllianceViewProfile.h"
#import "ViewPublicEmpireProfileController.h"


typedef enum {
	SECTION_INFO,
	SECTION_MEMBERS,
	SECTION_SPACE_STATIONS
} SECTION;


typedef enum {
	ALLIANCE_ROW_NAME,
	ALLIANCE_ROW_DESCRIPTION,
	ALLIANCE_ROW_LEADER,
	ALLIANCE_ROW_DATE_CREATED,
	ALLIANCE_ROW_INFLUENCE
} EMPIRE_ROW;




@implementation ViewAllianceProfileController


@synthesize allianceId;
@synthesize profile;


#pragma mark -
#pragma mark Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = SEPARATOR_COLOR;
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.title = @"Loading";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Alliance"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Members"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Space Stations"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[[[LEAllianceViewProfile alloc] initWithCallback:@selector(profileLoaded:) target:self allianceId:self.allianceId] autorelease];
}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.profile) {
		return 3;
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.profile) {
		switch (section) {
			case SECTION_INFO:
				return 5;
				break;
			case SECTION_MEMBERS:
				return [self.profile.members count];
				break;
			case SECTION_SPACE_STATIONS:
				return MAX([self.profile.spaceStations count], 1);
				break;
			default:
				return 0;
				break;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.profile) {
		switch (indexPath.section) {
			case SECTION_INFO:
				switch (indexPath.row) {
					case ALLIANCE_ROW_NAME:
					case ALLIANCE_ROW_LEADER:
					case ALLIANCE_ROW_DATE_CREATED:
					case ALLIANCE_ROW_INFLUENCE:
						return [LETableViewCellLabeledText getHeightForTableView:tableView];
						break;
					case ALLIANCE_ROW_DESCRIPTION:
						return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:self.profile.publicDescription];
						break;
					default:
						return 0.0;
						break;
				}
				break;
			case SECTION_MEMBERS:
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
				break;
			case SECTION_SPACE_STATIONS:
				; //DO NOT REMOVE
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
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
    
    UITableViewCell *cell;
	
	if (self.profile) {
		switch (indexPath.section) {
			case SECTION_INFO:
				switch (indexPath.row) {
					case ALLIANCE_ROW_NAME:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *allianceNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						allianceNameCell.label.text = @"Alliance";
						allianceNameCell.content.text = self.profile.name;
						cell = allianceNameCell;
						break;
					case ALLIANCE_ROW_DESCRIPTION:
						; //DO NOT REMOVE
						LETableViewCellLabeledParagraph *descriptionCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
						descriptionCell.label.text = @"Description";
						if (isNotNull(self.profile.publicDescription)) {
							descriptionCell.content.text = self.profile.publicDescription;
						} else {
							descriptionCell.content.text = @"";
						}
						cell = descriptionCell;
						break;
					case ALLIANCE_ROW_LEADER:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *leaderCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
						leaderCell.label.text = @"Leader";
						leaderCell.content.text = self.profile.leaderName;
						cell = leaderCell;
						break;
					case ALLIANCE_ROW_DATE_CREATED:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *dateCreatedCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						dateCreatedCell.label.text = @"Created";
						dateCreatedCell.content.text = [Util formatDate:self.profile.dateCreated];
						cell = dateCreatedCell;
						break;
					case ALLIANCE_ROW_INFLUENCE:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *influenceCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						influenceCell.label.text = @"Influence";
						influenceCell.content.text = [Util prettyNSDecimalNumber:self.profile.influence];
						cell = influenceCell;
						break;
					default:
						break;
				}
				break;
			case SECTION_MEMBERS:
				; //DO NOT REMOVE
				AllianceMember *allianceMember = [self.profile.members objectAtIndex:indexPath.row];
				LETableViewCellLabeledText *allianceCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
				allianceCell.label.text = @"Empire";
				allianceCell.content.text = allianceMember.name;
				cell = allianceCell;
				break;
			case SECTION_SPACE_STATIONS:
				if ([self.profile.spaceStations count] > 0) {
					NSMutableDictionary *spaceStation = [self.profile.spaceStations objectAtIndex:indexPath.row];
					LETableViewCellLabeledText *spaceStationCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					spaceStationCell.label.text = [NSString stringWithFormat:@"%@ x %@", [spaceStation objectForKey:@"x"], [spaceStation objectForKey:@"y"]];
					spaceStationCell.content.text = [spaceStation objectForKey:@"name"];
					cell = spaceStationCell;
				} else {
					LETableViewCellLabeledText *noSpaceStationCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					noSpaceStationCell.label.text = @"Space Stations";
					noSpaceStationCell.content.text = @"None";
					cell = noSpaceStationCell;
				}
				break;
			default:
				cell = nil;
				break;
		}
	} else {
		LETableViewCellLabeledText *notLoadedCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		notLoadedCell.label.text = @"Alliance";
		notLoadedCell.content.text = @"Not loaded";
		cell = notLoadedCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_INFO:
			switch (indexPath.row) {
				case ALLIANCE_ROW_LEADER:
					; // DO NOT REMOVE
					ViewPublicEmpireProfileController *viewPublicEmpireProfileController = [ViewPublicEmpireProfileController create];
					viewPublicEmpireProfileController.empireId = self.profile.leaderId;
					[self.navigationController pushViewController:viewPublicEmpireProfileController animated:YES];
					break;
			}
			break;
		case SECTION_MEMBERS:
			; //DO NOT REMOVE
			AllianceMember *allianceMember = [self.profile.members objectAtIndex:indexPath.row];
			ViewPublicEmpireProfileController *viewPublicEmpireProfileController = [ViewPublicEmpireProfileController create];
			viewPublicEmpireProfileController.empireId = allianceMember.empireId;
			[self.navigationController pushViewController:viewPublicEmpireProfileController animated:YES];
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
	self.profile = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.allianceId = nil;
	self.profile = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callbacks

- (id)profileLoaded:(LEAllianceViewProfile *)request {
	self.navigationItem.title = @"Public Profile";
	AlliancePublicProfile *newProfile = [[AlliancePublicProfile alloc] init];
	[newProfile parseData:request.profile];
	self.profile = newProfile;
	[self.tableView reloadData];
	[newProfile release];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewAllianceProfileController *) create {
	return [[[ViewAllianceProfileController alloc] init] autorelease];
}


@end

