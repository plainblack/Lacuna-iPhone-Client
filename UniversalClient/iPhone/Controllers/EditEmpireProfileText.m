//
//  EditEmpireProfileText.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/5/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "EditEmpireProfileText.h"
#import "LEEmpireEditProfile.h"
#import "LEViewSectionTab.h"
#import "LEMacros.h"
#import "EmpireProfile.h"


@implementation EditEmpireProfileText


@synthesize textCell;
@synthesize textName;
@synthesize textKey;


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
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.navigationItem.title = [NSString stringWithFormat:@"Edit %@", self.textName];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:self.textName]);
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.textCell = nil;
	self.textName = nil;
	self.textKey = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	[[LEEmpireEditProfile alloc] initWithCallback:@selector(textUpdated:) target:self textKey:self.textKey text:self.textCell.textView.text];
}


#pragma mark -
#pragma mark Callback Methods

- (id)textUpdated:(LEEmpireEditProfile *)request {
	[[self navigationController] popViewControllerAnimated:YES];
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (EditEmpireProfileText *)createForTextName:(NSString *)name textKey:(NSString *)key text:(NSString *)text {
	EditEmpireProfileText *editEmpireProfileText = [[[EditEmpireProfileText alloc] init] autorelease];
	
	editEmpireProfileText.textKey = key;
	editEmpireProfileText.textName = name;
	if ((id)text == [NSNull null]) {
		editEmpireProfileText.textCell.textView.text = @"";
	} else {
		editEmpireProfileText.textCell.textView.text = text;
	}
	
	return editEmpireProfileText;
}


@end

