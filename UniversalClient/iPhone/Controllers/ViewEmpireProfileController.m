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
#import "LETableViewCellParagraph.h"
#import "LETableViewCellLabeledSwitch.h"
#import "Util.h"
#import "LETableViewCellButton.h"
#import "ViewEmpireBoostsController.h"
#import "EditEmpireProfileText.h"
#import "LoginController.h"
#import "WebPageController.h"
#import "ViewMedalsController.h"
#import "EditTextFieldController.h"
#import "NewPasswordController.h"
#import "ViewRacialStatsController.h"
#import "LEEmpireEditProfile.h"

#define ISOLATIONIST_MSG @"Isolationist mode enabled. If you build an Espinoge Ministry or Colonize a second world you will no longer be an Isolationist and others can send spies to your colonies."

typedef enum {
	SECTION_EMPIRE,
	SECTION_ACTIONS,
	SECTION_SELF_DESTRUCT
} SECTION;


typedef enum {
	EMPIRE_ROW_NAME,
	EMPIRE_ROW_DESCRIPTION,
	EMPIRE_ROW_STATUS,
	EMPIRE_ROW_CITY,
	EMPIRE_ROW_COUNTRY,
	EMPIRE_ROW_SKYPE,
	EMPIRE_ROW_PLAYER_NAME,
	EMPIRE_ROW_EMAIL,
	EMPIRE_ROW_SITTER_PASSWORD,
	EMPIRE_ROW_ESSENTIA,
	EMPIRE_ROW_ISOLATIONIST
} EMPIRE_ROW;

typedef enum {
	ACTION_ROW_VIEW_EMPIRE_BOOSTS,
	ACTION_ROW_PURCHASE_ESSENTIA,
	ACTION_ROW_REDEEM_ESSENTIA_CODE,
	ACTION_ROW_VIEW_MEDALS,
	ACTION_ROW_VIEW_RACIAL_STATS,
	ACTION_ROW_CHANGE_PASSWORD,
	ACTION_ROW_SEND_INVITE
} ACTION_ROW;


@implementation ViewEmpireProfileController


@synthesize leEmpireViewProfile;
@synthesize empireProfile;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = SEPARATOR_COLOR;

	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
	self.navigationItem.title = @"Loading";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Empire"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Actions"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	Session *session = [Session sharedInstance];
	if (session.isLoggedIn) {
		self.leEmpireViewProfile = [[[LEEmpireViewProfile alloc] initWithCallback:@selector(profileLoaded:) target:self sessionId:session.sessionId] autorelease];
	}

}

- (void)viewDidDisappear:(BOOL)animated {
	[self.leEmpireViewProfile cancel];
	self.leEmpireViewProfile = nil;
	[super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	Session *session = [Session sharedInstance];
	if (session.empire.id) {
		return 3;
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	Session *session = [Session sharedInstance];
	if (session.empire.id) {
		switch (section) {
			case SECTION_EMPIRE:
				if (session.empire.isIsolationist) {
					return 11;
				} else {
					return 10;
				}
				break;
			case SECTION_ACTIONS:
				return 7;
				break;
			case SECTION_SELF_DESTRUCT:
				return 1;
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
	Session *session = [Session sharedInstance];
	if (session.empire.id) {
		switch (indexPath.section) {
			case SECTION_EMPIRE:
				switch (indexPath.row) {
					case EMPIRE_ROW_NAME:
					case EMPIRE_ROW_CITY:
					case EMPIRE_ROW_COUNTRY:
					case EMPIRE_ROW_SKYPE:
					case EMPIRE_ROW_PLAYER_NAME:
					case EMPIRE_ROW_EMAIL:
					case EMPIRE_ROW_SITTER_PASSWORD:
					case EMPIRE_ROW_ESSENTIA:
						return [LETableViewCellLabeledText getHeightForTableView:tableView];
						break;
					case EMPIRE_ROW_DESCRIPTION:
						return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:self.empireProfile.empireDescription];
						break;
					case EMPIRE_ROW_STATUS:
						return [LETableViewCellLabeledParagraph getHeightForTableView:tableView text:self.empireProfile.status];
						break;
					case EMPIRE_ROW_ISOLATIONIST:
						return [LETableViewCellParagraph getHeightForTableView:tableView text:ISOLATIONIST_MSG];
						break;
					default:
						return 0.0;
						break;
				}
				break;
			case SECTION_ACTIONS:
				switch (indexPath.row) {
					case ACTION_ROW_VIEW_EMPIRE_BOOSTS:
					case ACTION_ROW_PURCHASE_ESSENTIA:
					case ACTION_ROW_REDEEM_ESSENTIA_CODE:
					case ACTION_ROW_VIEW_MEDALS:
					case ACTION_ROW_VIEW_RACIAL_STATS:
					case ACTION_ROW_CHANGE_PASSWORD:
					case ACTION_ROW_SEND_INVITE:
						return [LETableViewCellButton getHeightForTableView:tableView];
						break;
					default:
						return 0.0;
						break;
				}
				break;
			case SECTION_SELF_DESTRUCT:
				return [LETableViewCellLabeledSwitch getHeightForTableView:tableView];
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

	Session *session = [Session sharedInstance];
	if (session.empire.id) {
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
						if ((id)self.empireProfile.empireDescription == [NSNull null]) {
							descriptionCell.content.text = @"";
						} else {
							descriptionCell.content.text = self.empireProfile.empireDescription;
						}
						descriptionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
						descriptionCell.selectionStyle = UITableViewCellSelectionStyleBlue;
						cell = descriptionCell;
						break;
					case EMPIRE_ROW_STATUS:
						; //DO NOT REMOVE
						LETableViewCellLabeledParagraph *statusCell = [LETableViewCellLabeledParagraph getCellForTableView:tableView];
						statusCell.label.text = @"Status";
						if ((id)self.empireProfile.status == [NSNull null]) {
							statusCell.content.text = @"";
						} else {
							statusCell.content.text = self.empireProfile.status;
						}
						statusCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
						statusCell.selectionStyle = UITableViewCellSelectionStyleBlue;
						cell = statusCell;
						break;
					case EMPIRE_ROW_CITY:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *cityCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
						cityCell.label.text = @"City";
						if ((id)self.empireProfile.city == [NSNull null]) {
							cityCell.content.text = @"";
						} else {
							cityCell.content.text = self.empireProfile.city;
						}
						cell = cityCell;
						break;
					case EMPIRE_ROW_COUNTRY:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *countryCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
						countryCell.label.text = @"Country";
						if ((id)self.empireProfile.country == [NSNull null]) {
							countryCell.content.text = @"";
						} else {
							countryCell.content.text = self.empireProfile.country;
						}
						cell = countryCell;
						break;
					case EMPIRE_ROW_SKYPE:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *skypeCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
						skypeCell.label.text = @"Skype";
						if ((id)self.empireProfile.skype == [NSNull null]) {
							skypeCell.content.text = @"";
						} else {
							skypeCell.content.text = self.empireProfile.skype;
						}
						cell = skypeCell;
						break;
					case EMPIRE_ROW_PLAYER_NAME:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *playerNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
						playerNameCell.label.text = @"Player Name";
						if ((id)self.empireProfile.playerName == [NSNull null]) {
							playerNameCell.content.text = @"";
						} else {
							playerNameCell.content.text = self.empireProfile.playerName;
						}
						cell = playerNameCell;
						break;
					case EMPIRE_ROW_EMAIL:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *emailCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
						emailCell.label.text = @"Email";
						if ((id)self.empireProfile.email == [NSNull null]) {
							emailCell.content.text = @"";
						} else {
							emailCell.content.text = self.empireProfile.email;
						}
						cell = emailCell;
						break;
					case EMPIRE_ROW_SITTER_PASSWORD:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *sitterPasswordCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
						sitterPasswordCell.label.text = @"Sitter Password";
						if ((id)self.empireProfile.sitterPassword == [NSNull null]) {
							sitterPasswordCell.content.text = @"";
						} else {
							sitterPasswordCell.content.text = self.empireProfile.sitterPassword;
						}
						cell = sitterPasswordCell;
						break;
					case EMPIRE_ROW_ESSENTIA:
						; //DO NOT REMOVE
						LETableViewCellLabeledText *essentiaCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
						essentiaCell.label.text = @"Essentia";
						essentiaCell.content.text = [NSString stringWithFormat:@"%@", session.empire.essentia];
						cell = essentiaCell;
						break;
					case EMPIRE_ROW_ISOLATIONIST:
						; //DO NOT REMOVE
						LETableViewCellParagraph *isolationistCell = [LETableViewCellParagraph getCellForTableView:tableView];
						isolationistCell.content.text = ISOLATIONIST_MSG;
						cell = isolationistCell;
						break;
					default:
						break;
				}
				break;
			case SECTION_ACTIONS:
				switch (indexPath.row) {
					case ACTION_ROW_VIEW_EMPIRE_BOOSTS:
						; //DO NOT REMOVE
						LETableViewCellButton *boostsButton = [LETableViewCellButton getCellForTableView:tableView];
						boostsButton.textLabel.text = @"View Empire Boosts";
						cell = boostsButton;
						break;
					case ACTION_ROW_PURCHASE_ESSENTIA:
						; //DO NOT REMOVE
						LETableViewCellButton *essentiaButton = [LETableViewCellButton getCellForTableView:tableView];
						essentiaButton.textLabel.text = @"Purchase Essentia";
						cell = essentiaButton;
						break;
					case ACTION_ROW_REDEEM_ESSENTIA_CODE:
						; //DO NOT REMOVE
						LETableViewCellButton *redeemEssentiaCodeButton = [LETableViewCellButton getCellForTableView:tableView];
						redeemEssentiaCodeButton.textLabel.text = @"Redeem Essentia Code";
						cell = redeemEssentiaCodeButton;
						break;
					case ACTION_ROW_VIEW_MEDALS:
						; //DO NOT REMOVE
						LETableViewCellButton *medalButton = [LETableViewCellButton getCellForTableView:tableView];
						medalButton.textLabel.text = @"View Medals";
						cell = medalButton;
						break;
					case ACTION_ROW_VIEW_RACIAL_STATS:
						; //DO NOT REMOVE
						LETableViewCellButton *racialStatsButton = [LETableViewCellButton getCellForTableView:tableView];
						racialStatsButton.textLabel.text = @"View Racial Stats";
						cell = racialStatsButton;
						break;
					case ACTION_ROW_CHANGE_PASSWORD:
						; //DO NOT REMOVE
						LETableViewCellButton *changePasswordButton = [LETableViewCellButton getCellForTableView:tableView];
						changePasswordButton.textLabel.text = @"Change Password";
						cell = changePasswordButton;
						break;
					case ACTION_ROW_SEND_INVITE:
						; //DO NOT REMOVE
						LETableViewCellButton *sendInviteButton = [LETableViewCellButton getCellForTableView:tableView];
						sendInviteButton.textLabel.text = @"Send Friend Invite";
						cell = sendInviteButton;
						break;
					default:
						cell = nil;
						break;
				}
				break;
			case SECTION_SELF_DESTRUCT:
				; //DO NOT REMOVE
				LETableViewCellLabeledSwitch *selfDestructCell = [LETableViewCellLabeledSwitch getCellForTableView:tableView];
				selfDestructCell.label.text = @"Self Destruct";
				selfDestructCell.isSelected = session.empire.selfDestructActive;
				selfDestructCell.delegate = self;
				cell = selfDestructCell;
				break;
			default:
				cell = nil;
				break;
		}
	} else {
		; //DO NOT REMOVE
		LETableViewCellLabeledText *empireNameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		empireNameCell.label.text = @"Empire";
		empireNameCell.content.text = @"Not loaded";
		cell = empireNameCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Session *session = [Session sharedInstance];
	if (session.empire.id) {
		switch (indexPath.section) {
			case SECTION_EMPIRE:
				switch (indexPath.row) {
					case EMPIRE_ROW_DESCRIPTION:
						; //DO NOT REMOVE
						NSLog(@"");
						EditEmpireProfileText *editDescriptionEmpireProfileText = [EditEmpireProfileText createForTextName:@"Description" textKey:@"description" text:self.empireProfile.empireDescription];
						[self.navigationController pushViewController:editDescriptionEmpireProfileText animated:YES];
						break;
					case EMPIRE_ROW_STATUS:
						; //DO NOT REMOVE
						EditEmpireProfileText *editStatusEmpireProfileText = [EditEmpireProfileText createForTextName:@"Status" textKey:@"status_message" text:self.empireProfile.status];
						[self.navigationController pushViewController:editStatusEmpireProfileText animated:YES];
						break;
					case EMPIRE_ROW_CITY:
						; //DO NOT REMOVE
						EditTextFieldController *editCityController = [EditTextFieldController createForTextName:@"City" textValue:self.empireProfile.city];
						editCityController.delegate = self;
						[self.navigationController pushViewController:editCityController animated:YES];
						break;
					case EMPIRE_ROW_COUNTRY:
						; //DO NOT REMOVE
						EditTextFieldController *editCountryController = [EditTextFieldController createForTextName:@"Country" textValue:self.empireProfile.country];
						editCountryController.delegate = self;
						[self.navigationController pushViewController:editCountryController animated:YES];
						break;
					case EMPIRE_ROW_SKYPE:
						; //DO NOT REMOVE
						EditTextFieldController *editSkypeController = [EditTextFieldController createForTextName:@"Skype" textValue:self.empireProfile.skype];
						editSkypeController.delegate = self;
						[self.navigationController pushViewController:editSkypeController animated:YES];
						break;
					case EMPIRE_ROW_PLAYER_NAME:
						; //DO NOT REMOVE
						EditTextFieldController *editPlayerNameController = [EditTextFieldController createForTextName:@"Player Name" textValue:self.empireProfile.playerName];
						editPlayerNameController.delegate = self;
						[self.navigationController pushViewController:editPlayerNameController animated:YES];
						break;
					case EMPIRE_ROW_EMAIL:
						; //DO NOT REMOVE
						EditTextFieldController *editEmailController = [EditTextFieldController createForTextName:@"Email" textValue:self.empireProfile.email];
						editEmailController.delegate = self;
						[self.navigationController pushViewController:editEmailController animated:YES];
						break;
					case EMPIRE_ROW_SITTER_PASSWORD:
						; //DO NOT REMOVE
						EditTextFieldController *editSitterPasswordController = [EditTextFieldController createForTextName:@"Sitter Password" textValue:self.empireProfile.sitterPassword];
						editSitterPasswordController.delegate = self;
						[self.navigationController pushViewController:editSitterPasswordController animated:YES];
						break;
				}
				break;
			case SECTION_ACTIONS:
				switch (indexPath.row) {
					case ACTION_ROW_VIEW_EMPIRE_BOOSTS:
						; //DO NOT REMOVE
						ViewEmpireBoostsController *viewEmpireBoostsController = [ViewEmpireBoostsController create];
						[self.navigationController pushViewController:viewEmpireBoostsController animated:YES];
						break;
					case ACTION_ROW_PURCHASE_ESSENTIA:
						; //DO NOT REMOVE
						NSString *purchaseUrl = [NSString stringWithFormat:@"%@pay?session_id=%@", session.serverUri, session.sessionId];
						WebPageController *webPageController = [WebPageController create];
						[webPageController goToUrl:purchaseUrl];
						[self presentModalViewController:webPageController animated:YES];
						break;
					case ACTION_ROW_REDEEM_ESSENTIA_CODE:
						; //DO NOT REMOVE
						EditTextFieldController *redeemEssentiaCodeController = [EditTextFieldController createForTextName:@"Essentia Code" textValue:@""];
						redeemEssentiaCodeController.delegate = self;
						[self.navigationController pushViewController:redeemEssentiaCodeController animated:YES];
						break;
					case ACTION_ROW_VIEW_MEDALS:
						; //DO NOT REMOVE
						ViewMedalsController *viewMedalsController = [ViewMedalsController create];
						viewMedalsController.medals = self.empireProfile.medals;
						[self.navigationController pushViewController:viewMedalsController animated:YES];
						break;
					case ACTION_ROW_VIEW_RACIAL_STATS:
						; //DO NOT REMOVE
						ViewRacialStatsController *viewRacialStatsController = [ViewRacialStatsController create];
						[self.navigationController pushViewController:viewRacialStatsController animated:YES];
						break;
					case ACTION_ROW_CHANGE_PASSWORD:
						; //DO NOT REMOVE
						NewPasswordController *newPasswordController = [NewPasswordController create];
						[self.navigationController pushViewController:newPasswordController animated:YES];
						break;
					case ACTION_ROW_SEND_INVITE:
						; //DO NOT REMOVE
						EditTextFieldController *sendInviteController = [EditTextFieldController createForTextName:@"Friend's Email" textValue:@""];
						sendInviteController.delegate = self;
						[self.navigationController pushViewController:sendInviteController animated:YES];
						break;
				}
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
	[self.leEmpireViewProfile cancel];
	self.leEmpireViewProfile = nil;
	self.empireProfile = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[self.leEmpireViewProfile cancel];
	self.leEmpireViewProfile = nil;
	self.empireProfile = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark LETableViewCellLabeledSwitchDelegate Methods

- (void)cell:(LETableViewCellLabeledSwitch *)cell switchedTo:(BOOL)isOn {
	Session *session = [Session sharedInstance];
	[session.empire setSelfDestruct:isOn];
}


#pragma mark -
#pragma mark EditTextFieldControllerDelegate Methods

- (BOOL)newTextEntryValue:(NSString *)value forTextName:(NSString *)textName {
	if ([textName isEqualToString:@"Essentia Code"]) {
		Session *session = [Session sharedInstance];
		[session.empire redeemEssentiaCode:value];
		return YES;
	} else if ([textName isEqualToString:@"Friend's Email"]) {
		if ([value rangeOfString:@"@"].location == NSNotFound) {
			UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"That does not appear to be a valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
			[av show];
			return NO;
		} else {
			Session *session = [Session sharedInstance];
			[session.empire sendInviteTo:value];
			return YES;
		}
	} else if ([textName isEqualToString:@"City"]) {
		[[LEEmpireEditProfile alloc] initWithCallback:@selector(textUpdated:) target:self textKey:@"city" text:value];
		return NO;
	} else if ([textName isEqualToString:@"Country"]) {
		[[LEEmpireEditProfile alloc] initWithCallback:@selector(textUpdated:) target:self textKey:@"country" text:value];
		return NO;
	} else if ([textName isEqualToString:@"Skype"]) {
		[[LEEmpireEditProfile alloc] initWithCallback:@selector(textUpdated:) target:self textKey:@"skype" text:value];
		return NO;
	} else if ([textName isEqualToString:@"Player Name"]) {
		[[LEEmpireEditProfile alloc] initWithCallback:@selector(textUpdated:) target:self textKey:@"player_name" text:value];
		return NO;
	} else if ([textName isEqualToString:@"Email"]) {
		[[LEEmpireEditProfile alloc] initWithCallback:@selector(textUpdated:) target:self textKey:@"email" text:value];
		return NO;
	} else if ([textName isEqualToString:@"Sitter Password"]) {
		[[LEEmpireEditProfile alloc] initWithCallback:@selector(textUpdated:) target:self textKey:@"sitter_password" text:value];
		return NO;
	} else {
		NSLog(@"Unhandled text name: %@", textName);
		return NO;
	}
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)logout {
	Session *session = [Session sharedInstance];
	[session logout];
}


#pragma mark -
#pragma mark Callbacks

- (id)profileLoaded:(LEEmpireViewProfile *)request {
	self.navigationItem.title = @"Empire Profile";
	self.empireProfile = request.empire;
	[self.tableView reloadData];
	return nil;
}


- (id)textUpdated:(LEEmpireEditProfile *)request {
	if ([request wasError]) {
		//Let Default error handler work
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
	return nil;
}

#pragma mark -
#pragma mark Class Methods

+ (ViewEmpireProfileController *) create {
	return [[[ViewEmpireProfileController alloc] init] autorelease];
}


@end

