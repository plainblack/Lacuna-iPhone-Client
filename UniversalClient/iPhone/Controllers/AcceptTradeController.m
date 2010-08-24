//
//  AcceptTradeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "AcceptTradeController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "Trade.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellLabeledText.h"
#import "LEBuildingAcceptTrade.h"
#import "LETableViewCellCaptchaImage.h"


typedef enum {
	ROW_CAPTCHA_IMAGE,
	ROW_CAPTCHA_SOLUTION
} ROWS;


@implementation AcceptTradeController


@synthesize baseTradeBuilding;
@synthesize trade;
@synthesize answerCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Accept Trade";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(acceptTrade)] autorelease];
	
	self.sectionHeaders = [NSArray array];
	
	self.answerCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.answerCell.label.text = @"Answer";
	self.answerCell.returnKeyType = UIReturnKeySend;
	self.answerCell.delegate = self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.answerCell becomeFirstResponder];
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
	return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_CAPTCHA_IMAGE:
			return [LETableViewCellCaptchaImage getHeightForTableView:tableView];
			break;
		case ROW_CAPTCHA_SOLUTION:
			return [LETableViewCellTextEntry getHeightForTableView:tableView];
			break;
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
	switch (indexPath.row) {
		case ROW_CAPTCHA_IMAGE:
			; //DO NOT REMOVE
			LETableViewCellCaptchaImage *captchaImageCell = [LETableViewCellCaptchaImage getCellForTableView:tableView];
			[captchaImageCell setCapthchaImageURL:self.baseTradeBuilding.captchaUrl];
			cell = captchaImageCell;
			break;
		case ROW_CAPTCHA_SOLUTION:
			; //DO NOT REMOVE
			cell = self.answerCell;
			break;
		default:
			break;
	}
	return cell;
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
	[super viewDidUnload];
}


- (void)dealloc {
	self.baseTradeBuilding = nil;
	self.trade = nil;
	self.answerCell = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.answerCell.textField) {
		[self acceptTrade];
	}
	
	return YES;
}


#pragma mark --
#pragma mark Instance Methods

- (IBAction)acceptTrade {
	[self.baseTradeBuilding acceptTrade:self.trade solution:self.answerCell.textField.text target:self callback:@selector(tradeAccepted:)];
}


#pragma mark -
#pragma mark Callback Methods

- (id)tradeAccepted:(LEBuildingAcceptTrade *)request {
	if ([request wasError]) {
		NSString *errorText = [request errorMessage];
		UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Could not accept trade." message:errorText delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		[av show];
		[request markErrorHandled];
	} else {
		[self.baseTradeBuilding.availableTrades removeObject:self.trade];
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (AcceptTradeController *)create {
	return [[[AcceptTradeController alloc] init] autorelease];
}


@end

