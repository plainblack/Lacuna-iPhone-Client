//
//  EditTextFieldController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "EditTextFieldController.h"
#import "LEViewSectionTab.h"
#import "LEMacros.h"
#import "LETableViewCellTextEntry.h"


@implementation EditTextFieldController


@synthesize textCell;
@synthesize textName;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (id)init {
	if ((self = [super init])) {
		self.textCell = [LETableViewCellTextEntry getCellForTableView:self.tableView];
		self.textCell.delegate = self;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Edit %@", self.textName];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:self.textName]);
	self.textCell.label.text = self.textName;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [LETableViewCellTextEntry getHeightForTableView:tableView];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.textCell;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	self.textCell = nil;
	self.textName = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)save {
	if ([self.delegate newTextEntryValue:self.textCell.textField.text forTextName:self.textName]) {
		[self.navigationController popViewControllerAnimated:YES];
	};
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.textCell.textField) {
		[self.textCell resignFirstResponder];
		[self save];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Class Methods

+ (EditTextFieldController *)createForTextName:(NSString *)inTextName textValue:(NSString *)inTextValue {
	EditTextFieldController *editTextViewController = [[[EditTextFieldController alloc] init] autorelease];
	editTextViewController.textName = inTextName;
	if ((id)inTextValue == [NSNull null]) {
		editTextViewController.textCell.textField.text = @"";
	} else {
		editTextViewController.textCell.textField.text = inTextValue;
	}
	
	return editTextViewController;
}


@end

