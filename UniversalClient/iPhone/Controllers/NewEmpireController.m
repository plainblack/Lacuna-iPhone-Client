//
//  NewEmpireController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewEmpireController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellCaptchaImage.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledSwitch.h"
#import "LEEmpireFetchCaptcha.h"
#import "LEEmpireCreate.h"
#import "SelectSpeciesTemplateController.h"
#import "WebPageController.h"
#import "AppDelegate_Phone.h"


typedef enum {
	SECTION_EMPIRE,
	SECTION_TOS,
	SECTION_NEXT
} SECTION;


typedef enum {
	EMPIRE_ROW_NAME,
	EMPIRE_ROW_PASSWORD,
	EMPIRE_ROW_PASSWORD_CONFIRM,
	EMPIRE_ROW_EMAIL,
	ROW_FRIEND_CODE
} EMPIRE_ROW;


typedef enum {
	TOS_TERMS_AGREE,
	TOS_TERMS_LINK,
	TOS_RULES_AGREE,
	TOS_RULES_LINK
} TOS_ROW;


typedef enum {
	NEXT_ROW_CAPTCHA_IMAGE,
	NEXT_ROW_CAPTCHA_SOLUTION,
	NEXT_ROW_NEXT_BUTTON
} NEXT_ROW;


@interface NewEmpireController (PrivateMethods)

- (void)showSpeciesSelect;

@end


@implementation NewEmpireController


@synthesize nameCell;
@synthesize passwordCell;
@synthesize passwordConfirmationCell;
@synthesize emailCell;
@synthesize friendCodeCell;
@synthesize termsAgreeCell;
@synthesize termsLinkCell;
@synthesize rulesAgreeCell;
@synthesize rulesLinkCell;
@synthesize captchaImageCell;
@synthesize captchaSolutionCell;
@synthesize nextButton;
@synthesize captchaGuid;
@synthesize captchaUrl;
@synthesize empireId;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"New Empire";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"New Empire"]);
	
	self.nameCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.nameCell.label.text = @"Name";
	self.nameCell.delegate = self;
	
	self.passwordCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordCell.label.text = @"Password";
	self.passwordCell.delegate = self;
	self.passwordCell.secureTextEntry = YES;
	
	self.passwordConfirmationCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.passwordConfirmationCell.label.text = @"Confirm";
	self.passwordConfirmationCell.delegate = self;
	self.passwordConfirmationCell.secureTextEntry = YES;
	
	self.emailCell = [LETableViewCellTextEntry getCellForTableView:self.tableView includeToolbar:YES isOptional:YES];
	self.emailCell.label.text = @"Email";
	self.emailCell.keyboardType = UIKeyboardTypeEmailAddress;
	self.emailCell.delegate = self;

	self.friendCodeCell = [LETableViewCellTextEntry getCellForTableView:self.tableView includeToolbar:YES isOptional:YES];
	self.friendCodeCell.label.text = @"Friend Code";
	self.friendCodeCell.delegate = self;
	
	self.termsAgreeCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.termsAgreeCell.label.text = @"I agree to Terms";
	
	self.termsLinkCell = [LETableViewCellButton getCellForTableView:self.tableView];
	self.termsLinkCell.textLabel.text = @"View Terms of Service";
	
	self.rulesAgreeCell = [LETableViewCellLabeledSwitch getCellForTableView:self.tableView];
	self.rulesAgreeCell.label.text = @"I agree to Rules";
	
	self.rulesLinkCell = [LETableViewCellButton getCellForTableView:self.tableView];
	self.rulesLinkCell.textLabel.text = @"View rules";
	
	self.captchaImageCell = [LETableViewCellCaptchaImage getCellForTableView:self.tableView];
	
	self.captchaSolutionCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.captchaSolutionCell.label.text = @"Solution";
	self.captchaSolutionCell.delegate = self;
	
	self.nextButton = [LETableViewCellButton getCellForTableView:self.tableView];
	self.nextButton.textLabel.text = @"Next";
	
#if TARGET_IPHONE_SIMULATOR
	self.nameCell.textField.text = @"bob";
	self.passwordCell.textField.text = @"abc123";
	self.passwordConfirmationCell.textField.text = @"abc123";
	self.emailCell.textField.text = @"";
#else
	self.nameCell.textField.text = @"";
	self.passwordCell.textField.text = @"";
	self.passwordConfirmationCell.textField.text = @"";
	self.emailCell.textField.text = @"";
#endif
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	if(!self.captchaGuid) {
		[[[LEEmpireFetchCaptcha alloc] initWithCallback:@selector(captchaFetched:) target:self] autorelease];
	}
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_EMPIRE:
			return  5;
			break;
		case SECTION_TOS:
			return  4;
			break;
		case SECTION_NEXT:
			return  3;
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
				case EMPIRE_ROW_PASSWORD:
				case EMPIRE_ROW_PASSWORD_CONFIRM:
				case EMPIRE_ROW_EMAIL:
				case ROW_FRIEND_CODE:
					return [LETableViewCellTextEntry getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		case SECTION_TOS:
			switch (indexPath.row) {
				case TOS_TERMS_AGREE:
				case TOS_RULES_AGREE:
					return [LETableViewCellLabeledSwitch getHeightForTableView:tableView];
					break;
				case TOS_TERMS_LINK:
				case TOS_RULES_LINK:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		case SECTION_NEXT:
			switch (indexPath.row) {
				case NEXT_ROW_CAPTCHA_SOLUTION:
					return [LETableViewCellTextEntry getHeightForTableView:tableView];
					break;
				case NEXT_ROW_CAPTCHA_IMAGE:
					return [LETableViewCellCaptchaImage getHeightForTableView:tableView];
					break;
				case NEXT_ROW_NEXT_BUTTON:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_EMPIRE:
			switch (indexPath.row) {
				case EMPIRE_ROW_NAME:
					return self.nameCell;
					break;
				case EMPIRE_ROW_PASSWORD:
					return self.passwordCell;
					break;
				case EMPIRE_ROW_PASSWORD_CONFIRM:
					return self.passwordConfirmationCell;
					break;
				case EMPIRE_ROW_EMAIL:
					return self.emailCell;
					break;
				case ROW_FRIEND_CODE:
					return self.friendCodeCell;
					break;
				default:
					return nil;
					break;
			}
			break;
		case SECTION_TOS:
			switch (indexPath.row) {
				case TOS_TERMS_AGREE:
					return self.termsAgreeCell;
					break;
				case TOS_TERMS_LINK:
					return self.termsLinkCell;
					break;
				case TOS_RULES_AGREE:
					return self.rulesAgreeCell;
					break;
				case TOS_RULES_LINK:
					return self.rulesLinkCell;
					break;
				default:
					return nil;
					break;
			}
			break;
		case SECTION_NEXT:
			switch (indexPath.row) {
				case NEXT_ROW_CAPTCHA_SOLUTION:
					return self.captchaSolutionCell;
					break;
				case NEXT_ROW_CAPTCHA_IMAGE:
					return self.captchaImageCell;
					break;
				case NEXT_ROW_NEXT_BUTTON:
					return self.nextButton;
					break;
				default:
					return nil;
					break;
			}
			break;
		default:
			return nil;
			break;
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.pendingRequest) {
		switch (indexPath.section) {
			case SECTION_TOS:
				switch (indexPath.row) {
					case TOS_TERMS_LINK:
						; //DO NOT REMOVE
						WebPageController *termsWebPageController = [WebPageController create];
						[termsWebPageController goToUrl:@"https://www.lacunaexpanse.com/terms/"];
						[self presentViewController:termsWebPageController animated:YES completion:nil];
						break;
					case TOS_RULES_LINK:
						; //DO NOT REMOVE
						WebPageController *rulesWebPageController = [WebPageController create];
						[rulesWebPageController goToUrl:@"https://www.lacunaexpanse.com/rules/"];
						[self presentViewController:rulesWebPageController animated:YES completion:nil];
						break;
						
					default:
						break;
				}
				break;
			case SECTION_NEXT:
				switch (indexPath.row) {
					case NEXT_ROW_NEXT_BUTTON:
						if (self.termsAgreeCell.isSelected && self.rulesAgreeCell.isSelected) {
							if (self.empireId) {
								[self showSpeciesSelect];
							} else {
								[[[LEEmpireCreate alloc] initWithCallback:@selector(empireCreated:) target:self name:self.nameCell.textField.text password:self.passwordCell.textField.text password1:self.passwordConfirmationCell.textField.text captchaGuid:self.captchaGuid captchaSolution:self.captchaSolutionCell.textField.text email:self.emailCell.textField.text inviteCode:self.friendCodeCell.textField.text] autorelease];
								self.pendingRequest = YES;
							}
						} else {
							UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Alert" message: @"You must agree to the Terms of Service and Rules." preferredStyle:UIAlertControllerStyleAlert];
							UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
												 { [av dismissViewControllerAnimated:YES completion:nil]; }];
							[av addAction: ok];
							[self presentViewController:av animated:YES completion:nil];
						}
						
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
	self.nameCell = nil;
	self.passwordCell = nil;
	self.passwordConfirmationCell = nil;
	self.emailCell = nil;
	self.friendCodeCell = nil;
	self.termsAgreeCell = nil;
	self.termsLinkCell = nil;
	self.rulesAgreeCell = nil;
	self.rulesLinkCell = nil;
	self.captchaImageCell = nil;
	self.captchaSolutionCell = nil;
	self.nextButton = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.nameCell = nil;
	self.passwordCell = nil;
	self.passwordConfirmationCell = nil;
	self.emailCell = nil;
	self.friendCodeCell = nil;
	self.termsAgreeCell = nil;
	self.termsLinkCell = nil;
	self.rulesAgreeCell = nil;
	self.rulesLinkCell = nil;
	self.captchaImageCell = nil;
	self.captchaSolutionCell = nil;
	self.nextButton = nil;
	self.captchaGuid = nil;
	self.captchaUrl = nil;
	self.empireId = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == nameCell.textField) {
		[self.nameCell resignFirstResponder];
		[self.passwordCell becomeFirstResponder];
	} else if (textField == passwordCell.textField) {
		[self.passwordCell resignFirstResponder];
		[self.passwordConfirmationCell becomeFirstResponder];
	} else if (textField == passwordConfirmationCell.textField) {
		[self.passwordConfirmationCell resignFirstResponder];
		[self.emailCell becomeFirstResponder];
	} else if (textField == emailCell.textField) {
		[self.emailCell resignFirstResponder];
		[self.friendCodeCell becomeFirstResponder];
	} else if (textField == self.friendCodeCell.textField) {
		[self.friendCodeCell resignFirstResponder];
	} else if (textField == captchaSolutionCell.textField) {
		[self.captchaSolutionCell resignFirstResponder];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)cancel {
	[self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)showSpeciesSelect {
	SelectSpeciesTemplateController *selectNewEmpireSpeciesController = [SelectSpeciesTemplateController create];
	selectNewEmpireSpeciesController.empireId = self.empireId;
	selectNewEmpireSpeciesController.username = self.nameCell.textField.text;
	selectNewEmpireSpeciesController.password = self.passwordCell.textField.text;
	[self.navigationController pushViewController:selectNewEmpireSpeciesController animated:YES];
}


#pragma mark -
#pragma mark Callbacks

- (id)captchaFetched:(LEEmpireFetchCaptcha *)request {
	self.captchaGuid = request.guid;
	self.captchaUrl = request.url;
	[self.captchaImageCell setCapthchaImageURL:self.captchaUrl];
	
	return nil;
}


- (id)empireCreated:(LEEmpireCreate *)request {
	self.pendingRequest = NO;
	if ([request wasError]) {
		switch ([request errorCode]) {
			case 1000:
				; //DO NOT REMOVE
				[request markErrorHandled];
				UIAlertController *nameAlertView = [UIAlertController alertControllerWithTitle:@"Could not create empire" message: @"Empire name invalid" preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [nameAlertView dismissViewControllerAnimated:YES completion:nil]; }];
				[nameAlertView addAction: ok];
				[self presentViewController:nameAlertView animated:YES completion:nil];
				break;
			case 1001:
				; //DO NOT REMOVE
				[request markErrorHandled];
				UIAlertController *passwordAlertView = [UIAlertController alertControllerWithTitle:@"Could not create empire" message: @"Password invalid" preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok2 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [passwordAlertView dismissViewControllerAnimated:YES completion:nil]; }];
				[passwordAlertView addAction: ok2];
				[self presentViewController:passwordAlertView animated:YES completion:nil];
				break;
			case 1014:
				; //DO NOT REMOVE
				[request markErrorHandled];
				UIAlertController *captchaAlertView = [UIAlertController alertControllerWithTitle:@"Captcha solution is incorrect." message:[request errorMessage] preferredStyle:UIAlertControllerStyleAlert];
				UIAlertAction* ok3 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
									 { [captchaAlertView dismissViewControllerAnimated:YES completion:nil]; }];
				[captchaAlertView addAction: ok3];
				[self presentViewController:captchaAlertView animated:YES completion:nil];
				self.captchaUrl = [[request errorData] objectForKey:@"url"];
				self.captchaGuid = [[request errorData] objectForKey:@"guid"];
				[self.captchaImageCell setCapthchaImageURL:self.captchaUrl];
				break;
			case 1100:
				; //DO NOT REMOVE
				[request markErrorHandled];
				AppDelegate_Phone *appDelegate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
				[appDelegate restartCreateEmpireId:[Util idFromDict:[request errorData] named:@"empire_id"] username:request.name password:request.password];
				break;
		}
		[self.tableView reloadData];
	} else {
		self.empireId = request.empireId;
		self.nameCell.enabled = NO;
		self.passwordCell.enabled = NO;
		self.passwordConfirmationCell.enabled = NO;
		self.emailCell.enabled = NO;
		self.captchaSolutionCell.enabled = NO;
		[self showSpeciesSelect];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (NewEmpireController *) create {
	return [[[NewEmpireController alloc] init] autorelease];
}


@end

