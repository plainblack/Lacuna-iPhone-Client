//
//  CaptchaViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/1/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "CaptchaViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "LERequest.h"
#import "LECaptchaFetch.h"
#import "LECaptchaSolve.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellCaptchaImage.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellButton.h"

typedef enum {
	ROW_CAPTCHA_IMAGE,
	ROW_CAPTCHA_SOLUTION,
	ROW_CAPTCHA_BUTTON,
} ROWS;


@implementation CaptchaViewController


@synthesize requestNeedingCaptcha;
@synthesize answerCell;
@synthesize captchaGuid;
@synthesize captchaUrl;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Live User Check";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(acceptTrade)] autorelease];
	
	
	self.answerCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.answerCell.label.text = @"Answer";
	self.answerCell.returnKeyType = UIReturnKeySend;
	self.answerCell.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if (!self.captchaGuid) {
		[[[LECaptchaFetch alloc] initWithCallback:@selector(captchaFetched:) target:self] autorelease];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
	if (self.captchaGuid) {
		return 3;
	} else {
		return 1;
	}

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.captchaGuid) {
		switch (indexPath.row) {
			case ROW_CAPTCHA_IMAGE:
				return [LETableViewCellCaptchaImage getHeightForTableView:tableView];
				break;
			case ROW_CAPTCHA_SOLUTION:
				return [LETableViewCellTextEntry getHeightForTableView:tableView];
				break;
			case ROW_CAPTCHA_BUTTON:
				return [LETableViewCellButton getHeightForTableView:tableView];
				break;
			default:
				return 0;
				break;
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}

}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	
	if (self.captchaGuid) {
		switch (indexPath.row) {
			case ROW_CAPTCHA_IMAGE:
				; //DO NOT REMOVE
				LETableViewCellCaptchaImage *captchaImageCell = [LETableViewCellCaptchaImage getCellForTableView:tableView];
				[captchaImageCell setCapthchaImageURL:self.captchaUrl];
				cell = captchaImageCell;
				break;
			case ROW_CAPTCHA_SOLUTION:
				; //DO NOT REMOVE
				cell = self.answerCell;
				break;
			case ROW_CAPTCHA_BUTTON:
				; //DO NOT REMOVE
				LETableViewCellButton *sendButtonCell = [LETableViewCellButton getCellForTableView:tableView];
				sendButtonCell.textLabel.text = @"Validate";
				cell = sendButtonCell;
				break;
			default:
				cell = nil;
				break;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Captcha";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}


	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.captchaGuid) {
		switch (indexPath.row) {
			case ROW_CAPTCHA_BUTTON:
				[[[LECaptchaSolve alloc] initWithCallback:@selector(captchaSolved:) target:self captchaGuid:self.captchaGuid captchaSolution:self.answerCell.textField.text] autorelease];
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
	self.answerCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.requestNeedingCaptcha = nil;
	self.answerCell = nil;
	self.captchaGuid = nil;
	self.captchaUrl = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return YES;
}


#pragma mark -
#pragma mark Callback Methods

- (void)captchaFetched:(LECaptchaFetch *)request {
	self.captchaUrl = request.captchaUrl;
	self.captchaGuid = request.captchaGuid;
	[self.tableView reloadData];
}


- (void)captchaSolved:(LECaptchaSolve *)request {
	if ([request wasError]) {
		NSString *errorText = [request errorMessage];
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Incorrect" message:errorText preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		
		switch ([request errorCode]) {
			case 1014:
				; //DO NOT REMOVE
				self.captchaUrl = [[request errorData] objectForKey:@"url"];
				self.captchaGuid = [[request errorData] objectForKey:@"guid"];
				break;
		}
		[request markErrorHandled];
		[self.tableView reloadData];
	} else {
		//RESEND
		[self.requestNeedingCaptcha resend];
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (CaptchaViewController *)create {
	return [[[CaptchaViewController alloc] init] autorelease];
}


@end

