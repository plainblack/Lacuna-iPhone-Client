//
//  NewEmpireController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewEmpireController.h"
#import "LEMacros.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellCaptchaImage.h"
#import "LETableViewCellButton.h"
#import "LEEmpireFetchCaptcha.h"
#import "LEEmpireCreate.h"
#import "SelectNewEmpireSpeciesController.h"


typedef enum {
	ROW_NAME,
	ROW_PASSWORD,
	ROW_PASSWORD_CONFIRM,
	ROW_EMAIL,
	ROW_CAPTCHA_IMAGE,
	ROW_CAPTCHA_SOLUTION,
	ROW_NEXT_BUTTON
} ROW;


@interface NewEmpireController (PrivateMethods)

- (void)showSpeciesSelect;

@end


@implementation NewEmpireController


@synthesize nameCell;
@synthesize passwordCell;
@synthesize passwordConfirmationCell;
@synthesize emailCell;
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
	self.hidesBottomBarWhenPushed = YES;
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"New Empire"]);
	
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
	
	self.emailCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.emailCell.label.text = @"Email";
	self.emailCell.delegate = self;
	
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
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_NAME:
		case ROW_PASSWORD:
		case ROW_PASSWORD_CONFIRM:
		case ROW_EMAIL:
		case ROW_CAPTCHA_SOLUTION:
			return [LETableViewCellTextEntry getHeightForTableView:tableView];
			break;
		case ROW_CAPTCHA_IMAGE:
			return [LETableViewCellCaptchaImage getHeightForTableView:tableView];
			break;
		case ROW_NEXT_BUTTON:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_NAME:
			return self.nameCell;
			break;
		case ROW_PASSWORD:
			return self.passwordCell;
			break;
		case ROW_PASSWORD_CONFIRM:
			return self.passwordConfirmationCell;
			break;
		case ROW_EMAIL:
			return self.emailCell;
			break;
		case ROW_CAPTCHA_IMAGE:
			return self.captchaImageCell;
			break;
		case ROW_CAPTCHA_SOLUTION:
			return self.captchaSolutionCell;
			break;
		case ROW_NEXT_BUTTON:
			return self.nextButton;
			break;
		default:
			return nil;
			break;
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_NEXT_BUTTON:
			if (self.empireId) {
				[self showSpeciesSelect];
			} else {
				[[[LEEmpireCreate alloc] initWithCallback:@selector(empireCreated:) target:self name:self.nameCell.textField.text password:self.passwordCell.textField.text password1:self.passwordConfirmationCell.textField.text captchaGuid:self.captchaGuid captchaSolution:self.captchaSolutionCell.textField.text email:self.emailCell.textField.text] autorelease];
			}
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
	self.nameCell = nil;
	self.passwordCell = nil;
	self.passwordConfirmationCell = nil;
	self.emailCell = nil;
	self.captchaImageCell = nil;
	self.captchaSolutionCell = nil;
	self.nextButton = nil;
	[self viewDidUnload];
}


- (void)dealloc {
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
		[self.captchaSolutionCell becomeFirstResponder];
	} else if (textField == captchaSolutionCell.textField) {
		[self.captchaSolutionCell resignFirstResponder];
	}
	
	return YES;
}


#pragma mark -
#pragma mark PrivateMethods

- (void)showSpeciesSelect {
	SelectNewEmpireSpeciesController *selectNewEmpireSpeciesController = [SelectNewEmpireSpeciesController create];
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
	if ([request wasError]) {
		switch ([request errorCode]) {
			case 1000:
				; //DO NOT REMOVE
				[request markErrorHandled];
				UIAlertView *nameAlertView = [[[UIAlertView alloc] initWithTitle:@"Could not create empire" message:@"Empire name invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[nameAlertView show];
				break;
			case 1001:
				; //DO NOT REMOVE
				[request markErrorHandled];
				UIAlertView *passwordAlertView = [[[UIAlertView alloc] initWithTitle:@"Could not create empire" message:@"Password invalid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[passwordAlertView show];
				break;
			case 1014:
				; //DO NOT REMOVE
				[request markErrorHandled];
				UIAlertView *captchaAlertView = [[[UIAlertView alloc] initWithTitle:@"Captcha solution is incorrect." message:[request errorMessage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
				[captchaAlertView show];
				break;
		}
	} else {
		self.empireId = request.empireId;
		self.nameCell.textField.enabled = NO;
		self.passwordCell.textField.enabled = NO;
		self.passwordConfirmationCell.textField.enabled = NO;
		self.emailCell.textField.enabled = NO;
		self.captchaSolutionCell.textField.enabled = NO;
		[self showSpeciesSelect];
	}
	
	return nil;
}


/*
- (id)empireFounded:(LEEmpireFound *) request {
	NSLog(@"Empire Founded");
	if ([request wasError]) {
		//WHAT TO DO?
	} else {
		[self dismissModalViewControllerAnimated:YES];
		Session *session = [Session sharedInstance];
		[session loginWithUsername:self.nameCell.textField.text password:self.passwordCell.textField.text];
		
	}
	
	return nil;
}
*/

#pragma mark -
#pragma mark Class Methods

+ (NewEmpireController *) create {
	return [[[NewEmpireController alloc] init] autorelease];
}


@end

