//
//  NewMailMessageController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewMailMessageController.h"
#import "LEMacros.h"
#import "LEInboxSend.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellTextView.h"
#import "SelectEmpireController.h"


typedef enum {
	SECTION_TO,
	SECTION_SUBJECT,
	SECTION_BODY
} SECTION;


typedef enum {
	TO_ROW_MAIN_CALL,
	TO_ROW_ADD_EMPIRE,
	TO_ROW_ADD_ALLIES
} TO_ROW;


@implementation NewMailMessageController


@synthesize toCell;
@synthesize subjectCell;
@synthesize messageCell;
@synthesize replyToMessage;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"New Message";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sendMessage)] autorelease];

	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"To"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Subject"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Message"]);
	
	self.toCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.toCell.label.text = @"To";
	self.toCell.delegate = self;
	
	self.subjectCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
	self.subjectCell.label.text = @"Subject";
	self.subjectCell.delegate = self;
	
	self.messageCell = [LETableViewCellTextView getCellForTableView:self.tableView];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (replyToMessage) {
		self.navigationItem.title = @"Reply";
		self.toCell.textField.text = [replyToMessage objectForKey:@"from"];
		self.subjectCell.textField.text = [NSString stringWithFormat:@"RE: %@", [replyToMessage objectForKey:@"subject"]];
		self.messageCell.textView.text = [NSString stringWithFormat:@"\nIn reply to:\n%@", [replyToMessage objectForKey:@"body"]];
	}
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (replyToMessage) {
		[self.messageCell becomeFirstResponder];
		self.messageCell.textView.selectedRange = NSRangeZero;
	} else {
		[self.toCell becomeFirstResponder];
	}
}

	
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_TO:
			return 3;
			break;
		case SECTION_SUBJECT:
			return 1;
			break;
		case SECTION_BODY:
			return 1;
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_TO:
			switch (indexPath.row) {
				case TO_ROW_MAIN_CALL:
					return [LETableViewCellTextEntry getHeightForTableView:tableView];
					break;
				case TO_ROW_ADD_EMPIRE:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				case TO_ROW_ADD_ALLIES:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return 0.0;
					break;
			}
			return [tableView rowHeight];
		case SECTION_SUBJECT:
			return [LETableViewCellTextEntry getHeightForTableView:tableView];
		case SECTION_BODY:
			return [LETableViewCellTextView getHeightForTableView:tableView];
		default:
			return 0.0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	switch (indexPath.section) {
		case SECTION_TO:
			switch (indexPath.row) {
				case TO_ROW_MAIN_CALL:
					return self.toCell;
					break;
				case TO_ROW_ADD_EMPIRE:
					; //DO NOT REMOVE
					LETableViewCellButton *addEmpireButton = [LETableViewCellButton getCellForTableView:tableView];
					addEmpireButton.textLabel.text = @"Add Empire";
					return addEmpireButton;
					break;
				case TO_ROW_ADD_ALLIES:
					; //DO NOT REMOVE
					LETableViewCellButton *addAlliesButton = [LETableViewCellButton getCellForTableView:tableView];
					addAlliesButton.textLabel.text = @"Add Allies";
					return addAlliesButton;
					break;
			}
			break;
		case SECTION_SUBJECT:
			return self.subjectCell;
			break;
		case SECTION_BODY:
			return self.messageCell;
			break;
	}
	return nil;
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_TO:
			switch (indexPath.row) {
				case TO_ROW_ADD_EMPIRE:
					; //DO NOT REMOVE
					SelectEmpireController *selectEmpireController = [SelectEmpireController create];
					selectEmpireController.delegate = self;
					[self.navigationController pushViewController:selectEmpireController animated:YES];
					break;
				case TO_ROW_ADD_ALLIES:
					[self addTo:@"@ally"];
					break;
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
	self.toCell = nil;
	self.subjectCell = nil;
	self.messageCell = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.toCell = nil;
	self.subjectCell = nil;
	self.messageCell = nil;
	self.replyToMessage = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark SelectEmpireControllerDelegate Methods

- (void)selectedEmpire:(NSDictionary *)empire {
	[self addTo:[empire objectForKey:@"name"]];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Instance Methods

- (void)addTo:(NSString *)to {
	if ([self.toCell.textField.text length] > 0) {
		self.toCell.textField.text = [NSString stringWithFormat:@"%@, %@", self.toCell.textField.text, to];
	} else {
		self.toCell.textField.text = to;
	}
}


- (IBAction)cancelMessage {
	[self.toCell resignFirstResponder];
	[self.subjectCell resignFirstResponder];
	[self.messageCell resignFirstResponder];
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)sendMessage {
	[self.toCell resignFirstResponder];
	[self.subjectCell resignFirstResponder];
	[self.messageCell resignFirstResponder];
	
	NSDictionary *options;
	
	if (replyToMessage) {
		options = [NSDictionary dictionaryWithObject:[replyToMessage objectForKey:@"id"] forKey:@"in_reply_to"];
	} else {
		options = [NSDictionary dictionary];
	}
	
	[[[LEInboxSend alloc] initWithCallback:@selector(messageSent:) target:self recipients:self.toCell.textField.text subject:self.subjectCell.textField.text body:self.messageCell.textView.text options:options] autorelease];
}


#pragma mark -
#pragma mark Callbacks


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == toCell.textField) {
		[toCell resignFirstResponder];
		[subjectCell becomeFirstResponder];
	} else if (textField == subjectCell.textField) {
		[subjectCell resignFirstResponder];
		[messageCell becomeFirstResponder];
	} else {
		[messageCell resignFirstResponder];
		[self sendMessage];
	}
	
	return YES;
}


- (id)messageSent:(LEInboxSend *)request {
	[self.navigationController popViewControllerAnimated:YES];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (NewMailMessageController *)create {
	return [[[NewMailMessageController alloc] init] autorelease];
}


@end

