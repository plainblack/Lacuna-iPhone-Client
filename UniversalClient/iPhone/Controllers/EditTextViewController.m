//
//  EditTextViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/28/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "EditTextViewController.h"
#import "LEViewSectionTab.h"
#import "LEMacros.h"
#import "LETableViewCellTextView.h"


@implementation EditTextViewController


@synthesize textCell;
@synthesize textName;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (id)init {
	if (self = [super init]) {
		self.textCell = [LETableViewCellTextView getCellForTableView:self.tableView];
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
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:self.textName]);
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
	return [LETableViewCellTextView getHeightForTableView:tableView];
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
	[self viewDidUnload];
}


- (void)dealloc {
	self.textCell = nil;
	self.textName = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)save {
	if ([self.delegate newTextValue:self.textCell.textView.text forTextName:self.textName]) {
		[self.navigationController popViewControllerAnimated:YES];
	};
}


#pragma mark -
#pragma mark Class Methods

+ (EditTextViewController *)createForTextName:(NSString *)inTextName textValue:(NSString *)inTextValue {
	EditTextViewController *editTextViewController = [[[EditTextViewController alloc] init] autorelease];
	editTextViewController.textName = inTextName;
	if ((id)inTextValue == [NSNull null]) {
		editTextViewController.textCell.textView.text = @"";
	} else {
		editTextViewController.textCell.textView.text = inTextValue;
	}
	
	return editTextViewController;
}


@end

