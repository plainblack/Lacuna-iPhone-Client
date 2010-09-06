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
#import "LETableViewCellTextEntry.h"
#import "LETableViewCellTextView.h"


typedef enum {
	SECTION_HEADER,
	SECTION_BODY
} SECTION;

typedef enum {
	HEADER_ROW_TO,
	HEADER_ROW_SUBJECT
} HEADER_ROW;


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
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_HEADER:
			return 2;
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
		case SECTION_HEADER:
			return [tableView rowHeight];
		case SECTION_BODY:
			return 150.0f;
		default:
			return [tableView rowHeight];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	switch (indexPath.section) {
		case SECTION_HEADER:
			switch (indexPath.row) {
				case HEADER_ROW_TO:
					return self.toCell;
					break;
				case HEADER_ROW_SUBJECT:
					return self.subjectCell;
					break;
			}
			break;
		case SECTION_BODY:
			return self.messageCell;
			break;
	}
	return nil;
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
	self.toCell = nil;
	self.subjectCell = nil;
	self.messageCell = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.replyToMessage = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods


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

