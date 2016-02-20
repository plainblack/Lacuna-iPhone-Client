//
//  SelectServerController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectServerController.h"
#import "LEMacros.h"
#import "Servers.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellServerSelect.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellTextEntry.h"


typedef enum {
	SECTION_SERVER_LIST,
	SECTION_CUSTOM_SERVER
} SECTIONS;


typedef enum {
	CUSTOM_SERVER_ROW_ENTRY,
	CUSTOM_SERVER_ROW_BUTTON
} CUSTOM_SERVER_ROW;


@implementation SelectServerController


@synthesize servers;
@synthesize delegate;
@synthesize customerServerCell;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)] autorelease];
    

	self.navigationItem.title = @"Select Server";
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Servers"], [LEViewSectionTab tableView:self.tableView withText:@"Custom"]);
	self.servers = [[[Servers alloc] init] autorelease];

	self.customerServerCell =  [LETableViewCellTextEntry getCellForTableView:self.tableView includeToolbar:NO];
	self.customerServerCell.label.text = @"URL";
	self.customerServerCell.keyboardType = UIKeyboardTypeURL;
	self.customerServerCell.delegate = self;

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.servers loadServers];

//#if TARGET_IPHONE_SIMULATOR
	self.customerServerCell.textField.text = @"https://pt.lacunaexpanse.com";
//#endif
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_SERVER_LIST:
			return MAX([self.servers.serverList count], 1);
			break;
		case SECTION_CUSTOM_SERVER:
			return 2;
			break;
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_SERVER_LIST:
			if (self.servers.serverList) {
				if ([self.servers.serverList count] > 0) {
					return [LETableViewCellServerSelect getHeightForTableView:tableView];
				} else {
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
				}
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
			break;
		case SECTION_CUSTOM_SERVER:
			switch (indexPath.row) {
				case CUSTOM_SERVER_ROW_ENTRY:
					return [LETableViewCellTextEntry getHeightForTableView:tableView];
					break;
				case CUSTOM_SERVER_ROW_BUTTON:
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
	UITableViewCell *cell = nil;

	switch (indexPath.section) {
		case SECTION_SERVER_LIST:
			if (self.servers.serverList) {
				if ([self.servers.serverList count] > 0) {
					NSDictionary *server = [self.servers.serverList objectAtIndex:indexPath.row];
					LETableViewCellServerSelect *serverButtonCell = [LETableViewCellServerSelect getCellForTableView:tableView];
					[serverButtonCell setServer:server];
					cell = serverButtonCell;
				} else {
					LETableViewCellLabeledText *noMatchesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					noMatchesCell.label.text = @"Servers";
					noMatchesCell.content.text = @"No Matches";
					cell = noMatchesCell;
				}
			} else {
				LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingCell.label.text = @"Servers";
				loadingCell.content.text = @"Loading";
				cell = loadingCell;
			}
			break;
		case SECTION_CUSTOM_SERVER:
			switch (indexPath.row) {
				case CUSTOM_SERVER_ROW_ENTRY:
					; //DO NOT REMOVE
					cell = self.customerServerCell;
					break;
				case CUSTOM_SERVER_ROW_BUTTON:
					; //DO NOT REMOVE
					LETableViewCellButton *customButtonCell = [LETableViewCellButton getCellForTableView:tableView];
					customButtonCell.textLabel.text = @"Use Custom";
					cell = customButtonCell;
					break;
			}
			break;
	}
	
	
	return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_SERVER_LIST:
			if (self.servers.serverList) {
				if ([self.servers.serverList count] > 0) {
					NSDictionary *server = [self.servers.serverList objectAtIndex:indexPath.row];
					[self.delegate selectedServer:server];
				}
			}
			break;
		case SECTION_CUSTOM_SERVER:
			switch (indexPath.row) {
				case CUSTOM_SERVER_ROW_BUTTON:
					; //DO NOT REMOVE
					NSDictionary *server = _dict(@"Custom", @"location", @"Custom", @"name", @"Custom", @"status", self.customerServerCell.textField.text, @"uri");
					[self.delegate selectedServer:server];
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
	self.servers = nil;
	self.customerServerCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.servers = nil;
	self.customerServerCell = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (IBAction)cancel {
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.customerServerCell.textField) {
		[self.customerServerCell resignFirstResponder];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Class Methods

+ (SelectServerController *)create {
	return [[[SelectServerController alloc] init] autorelease];
}


@end

