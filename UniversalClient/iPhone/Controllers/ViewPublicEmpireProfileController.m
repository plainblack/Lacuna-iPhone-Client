//
//  ViewPublicEmpireProfileController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewPublicEmpireProfileController.h"
#import "LEEmpireViewPublicProfile.h"
#import "LEViewSectionTab.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "PublicEmpireProfile.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledParagraph.h"
#import "LETableViewCellBody.h"
#import "LETableViewCellMedal.h"
#import "WebPageController.h"
#import "AppDelegate_Phone.h"


typedef enum {
	SECTION_EMPIRE,
	SECTION_COLONIES,
	SECTION_MEDALS
} SECTION;


typedef enum {
	EMPIRE_ROW_NAME,
	EMPIRE_ROW_SPECIES,
	EMPIRE_ROW_LAST_LOGIN,
	EMPIRE_ROW_EMPIRE_FOUNDED,
	EMPIRE_ROW_STATUS,
	EMPIRE_ROW_DESCRIPTION,
	EMPIRE_ROW_CITY,
	EMPIRE_ROW_COUNTRY,
	EMPIRE_ROW_SKYPE,
	EMPIRE_ROW_PLAYER_NAME
} EMPIRE_ROW;


@implementation ViewPublicEmpireProfileController


@synthesize empireId;
@synthesize profile;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = SEPARATOR_COLOR;
	
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.title = @"Loading";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Empire"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Colonies"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Medals"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	Session *session = [Session sharedInstance];
	[[[LEEmpireViewPublicProfile alloc] initWithCallback:@selector(profileLoaded:) target:self sessionId:session.sessionId empireId:self.empireId] autorelease];
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
			case SECTION_EMPIRE:
				return 10;
				break;
			case SECTION_COLONIES:
				return [self.profile.colonies count];
				break;
			case SECTION_MEDALS:
				return [self.profile.medals count];
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
			case SECTION_EMPIRE:
				switch (indexPath.row) {
					case EMPIRE_ROW_NAME:
					case EMPIRE_ROW_SPECIES:
					case EMPIRE_ROW_LAST_LOGIN:
					case EMPIRE_ROW_EMPIRE_FOUNDED:
					case EMPIRE_ROW_CITY:
					case EMPIRE_ROW_COUNTRY:
					case EMPIRE_ROW_SKYPE:
					case EMPIRE_ROW_PLAYER_NAME:
						return [LETableViewCellLabeledText getHeightForTableView:tableView];
						break;
					case EMPIRE_ROW_DESCRIPTION:
						return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:self.profile.empireDescription];
						break;
					case EMPIRE_ROW_STATUS:
						return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:self.profile.status];
						break;
					default:
						return 0.0;
						break;
				}
				break;
			case SECTION_COLONIES:
				return [LETableViewCellBody getHeightForTableView:tableView];
				break;
			case SECTION_MEDALS:
				; //DO NOT REMOVE
				NSDictionary *medalData = [self.profile.medals objectAtIndex:indexPath.row];
				return [LETableViewCellMedal getHeightForTableView:tableView withMedal:medalData];
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
			case SECTION_EMPIRE:
				switch (indexPath.row) {
					case EMPIRE_ROW_NAME:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *empireNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						empireNameCell.label.text = @"Empire";
						empireNameCell.content.text = self.profile.name;
						cell = empireNameCell;
						break;
					case EMPIRE_ROW_DESCRIPTION:
						; //DO NOT REMOVE
						LETableViewCellLabeledParagraph *descriptionCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
						descriptionCell.label.text = @"Description";
						if (isNotNull(self.profile.empireDescription)) {
							descriptionCell.content.text = self.profile.empireDescription;
						} else {
							descriptionCell.content.text = @"";
						}
						cell = descriptionCell;
						break;
					case EMPIRE_ROW_STATUS:
						; //DO NOT REMOVE
						LETableViewCellLabeledParagraph *statusCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
						statusCell.label.text = @"Status";
						if (isNotNull(self.profile.status)) {
							statusCell.content.text = self.profile.status;
						} else {
							statusCell.content.text = @"";
						}
						cell = statusCell;
						break;
					case EMPIRE_ROW_CITY:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *cityCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						cityCell.label.text = @"City";
						if (isNotNull(self.profile.city)) {
							cityCell.content.text = self.profile.city;
						} else {
							cityCell.content.text = @"";
						}
						cell = cityCell;
						break;
					case EMPIRE_ROW_COUNTRY:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *countryCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						countryCell.label.text = @"Country";
						if (isNotNull(self.profile.country)) {
							countryCell.content.text = self.profile.country;
						} else {
							countryCell.content.text = @"";
						}
						cell = countryCell;
						break;
					case EMPIRE_ROW_SKYPE:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *skypeCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						skypeCell.label.text = @"Skype";
						if (isNotNull(self.profile.skype)) {
							skypeCell.content.text = self.profile.skype;
						} else {
							skypeCell.content.text = @"";
						}
						cell = skypeCell;
						break;
					case EMPIRE_ROW_PLAYER_NAME:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *playerNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						playerNameCell.label.text = @"Player Name";
						if (isNotNull(self.profile.playerName)) {
							playerNameCell.content.text = self.profile.playerName;
						} else {
							playerNameCell.content.text = @"";
						}
						cell = playerNameCell;
						break;
					case EMPIRE_ROW_SPECIES:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *speciesNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						speciesNameCell.label.text = @"Species Name";
						if (isNotNull(self.profile.speciesName)) {
							speciesNameCell.content.text = self.profile.speciesName;
						} else {
							speciesNameCell.content.text = @"";
						}
						cell = speciesNameCell;
						break;
					case EMPIRE_ROW_LAST_LOGIN:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *lastLoginCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						lastLoginCell.label.text = @"Last Login";
						if (isNotNull(self.profile.lastLogin)) {
							lastLoginCell.content.text = [Util formatDate:self.profile.lastLogin];
						} else {
							lastLoginCell.content.text = @"";
						}
						cell = lastLoginCell;
						break;
					case EMPIRE_ROW_EMPIRE_FOUNDED:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *foundedCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						foundedCell.label.text = @"Founded";
						if (isNotNull(self.profile.founded)) {
							foundedCell.content.text = [Util formatDate:self.profile.founded];
						} else {
							foundedCell.content.text = @"";
						}
						cell = foundedCell;
						break;
					default:
						break;
				}
				break;
			case SECTION_COLONIES:
				; //DO NOT REMOVE
				NSDictionary *body = [self.profile.colonies objectAtIndex:indexPath.row];
				LETableViewCellBody *colonyCell = [LETableViewCellBody getCellForTableView:tableView];
				colonyCell.planetImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"/assets/star_system/%@.png", [body objectForKey:@"image"]]];
				colonyCell.planetLabel.text = [body objectForKey:@"name"];
				colonyCell.systemLabel.text = @"Unknown";
				colonyCell.orbitLabel.text = @"Unknown";
				colonyCell.empireLabel.text = self.profile.name;
				colonyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				colonyCell.selectionStyle = UITableViewCellSelectionStyleBlue;
				cell = colonyCell;
				break;
			case SECTION_MEDALS:
				; //DO NOT REMOVE
				NSDictionary *medalData = [self.profile.medals objectAtIndex:indexPath.row];
				LETableViewCellMedal *medalCell = [LETableViewCellMedal getCellForTableView:tableView];
				[medalCell setData:medalData];
				cell = medalCell;
				break;
			default:
				cell = nil;
				break;
		}
	} else {
		LETableViewCellLabeledText *notLoadedCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		notLoadedCell.label.text = @"Empire";
		notLoadedCell.content.text = @"Not loaded";
		cell = notLoadedCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.profile) {
		switch (indexPath.section) {
			case SECTION_COLONIES:
				; //DO NOT REMOVE
				NSDictionary *body = [self.profile.colonies objectAtIndex:indexPath.row];
				AppDelegate_Phone *appDelegate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
				[appDelegate showStarMapGridX:[Util asNumber:[body objectForKey:@"x"]] gridY:[Util asNumber:[body objectForKey:@"y"]]];
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
	self.profile = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.empireId = nil;
	self.profile = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callbacks

- (id)profileLoaded:(LEEmpireViewPublicProfile *)request {
	self.navigationItem.title = @"Public Profile";
	PublicEmpireProfile *newProfile = [[[PublicEmpireProfile alloc] init] autorelease];
	[newProfile parseData:request.profile];
	self.profile = newProfile;
	[self.tableView reloadData];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (ViewPublicEmpireProfileController *) create {
	return [[[ViewPublicEmpireProfileController alloc] init] autorelease];
}


@end

