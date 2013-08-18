//
//  BuildStashDonationController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BuildStashDonationController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Embassy.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLongLabeledText.h"
#import "SelectResourceTypeFromListController.h"
#import "LEBuildingDonateToStash.h"


@implementation BuildStashDonationController


@synthesize embassy;
@synthesize donatedResources;
@synthesize donatedResourceKeys;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Stash Donate";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Donation"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if (!self.donatedResources) {
		self.donatedResources = [NSMutableDictionary dictionaryWithCapacity:5];
		self.donatedResourceKeys = [NSArray array];
	}
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.donatedResources count]+1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [self.donatedResources count]) {
		return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
	} else {
		return [LETableViewCellButton getHeightForTableView:tableView];
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [self.donatedResources count]) {
		NSString *key = [self.donatedResourceKeys objectAtIndex:indexPath.row];
		LETableViewCellLongLabeledText *donatedResourceCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
		donatedResourceCell.label.text = [Util prettyCodeValue:key];
		donatedResourceCell.content.text = [Util prettyNSDecimalNumber:[self.donatedResources objectForKey:key] ];
		return donatedResourceCell;
	} else {
		LETableViewCellButton *addButton = [LETableViewCellButton getCellForTableView:tableView];
		addButton.textLabel.text = @"Add";
		return addButton;
	}
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row >= [self.donatedResources count]) {
		SelectResourceTypeFromListController *selectResourceTypeFromListController = [SelectResourceTypeFromListController create];
		selectResourceTypeFromListController.storedResourceTypes = self.embassy.storedResources;
		selectResourceTypeFromListController.delegate = self;
		[self.navigationController pushViewController:selectResourceTypeFromListController animated:YES];
	}
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath.row < [self.donatedResources count];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Row: %i, Count: %i", indexPath.row, [self.donatedResources count]);
	NSLog(@"Delete Style: %i, Editing Style: %i", UITableViewCellEditingStyleDelete, editingStyle);
	if ( (indexPath.row < [self.donatedResources count]) && (editingStyle == UITableViewCellEditingStyleDelete) ) {
		NSString *type = [self.donatedResourceKeys objectAtIndex:indexPath.row];
		NSDecimalNumber *amount = [self.donatedResources objectForKey:type];
		NSDecimalNumber *oldValue = [self.embassy.storedResources objectForKey:type];
		NSDecimalNumber	*newValue = [oldValue decimalNumberByAdding:amount];
		[self.embassy.storedResources setObject:newValue forKey:type];
		[self.donatedResources removeObjectForKey:type];
		self.donatedResourceKeys = [self.donatedResources keysSortedByValueUsingSelector:@selector(compare:)];
		[tableView reloadData];
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.embassy = nil;
	self.donatedResources = nil;
	self.donatedResourceKeys = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	[self.embassy donateToStash:self.donatedResources target:self callback:@selector(donated:)];
}


#pragma mark -
#pragma mark SelectResourceTypeFromListControllerDelegate

- (void)selectedStoredResourceType:(NSString *)type amount:(NSDecimalNumber *)amount {
	NSDecimalNumber *donatedAmount = [self.donatedResources objectForKey:type];
	if (donatedAmount) {
		[self.donatedResources setObject:[donatedAmount decimalNumberByAdding:amount] forKey:type];
	} else {
		[self.donatedResources setObject:amount forKey:type];
		self.donatedResourceKeys = [self.donatedResources keysSortedByValueUsingSelector:@selector(compare:)];
	}
	
	NSDecimalNumber *oldValue = [self.embassy.storedResources objectForKey:type];
	NSDecimalNumber *newValue = [oldValue decimalNumberBySubtracting:amount];
	[self.embassy.storedResources setObject:newValue forKey:type];
	
	[self.navigationController popToViewController:self animated:YES];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Callback Methods

- (void)donated:(LEBuildingDonateToStash *)request {
	if (![request wasError]) {
		[[self navigationController] popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (BuildStashDonationController *)create {
	return [[[BuildStashDonationController alloc] init] autorelease];
}


@end

