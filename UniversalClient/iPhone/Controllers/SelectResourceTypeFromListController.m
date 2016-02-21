//
//  SelectResourceTypeFromListController.m
//  UniversalClient
//
//  Created by Kevin Runde on 11/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectResourceTypeFromListController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"


@implementation SelectResourceTypeFromListController


@synthesize storedResourceTypes;
@synthesize storedResourceTypeKeys;
@synthesize selectedStoredResourceTypeKey;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Resource Type";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Resource Types"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.storedResourceTypeKeys = [NSMutableArray arrayWithCapacity:[self.storedResourceTypes count]];
	[self.storedResourceTypes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        NSDecimalNumber *number = [Util asNumber:obj];
		if (![number isEqualToNumber:[NSDecimalNumber zero]]) {
			[self.storedResourceTypeKeys addObject:key];
		}
	}];
	[self.storedResourceTypeKeys sortUsingSelector: @selector(caseInsensitiveCompare:)];
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
	if ([self.storedResourceTypeKeys count] > 0) {
		return [self.storedResourceTypeKeys count];
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.storedResourceTypeKeys count] > 0) {
		return [LETableViewCellButton getHeightForTableView:tableView];
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
	
	if ([self.storedResourceTypeKeys count] > 0) {
		NSString *storedResourceTypeKey = [self.storedResourceTypeKeys objectAtIndex:indexPath.row];
		NSDecimalNumber *storedResourceTypeQuantity = [self.storedResourceTypes objectForKey:storedResourceTypeKey];
		LETableViewCellButton *storedResourceCell = [LETableViewCellButton getCellForTableView:tableView];
		storedResourceCell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", [storedResourceTypeKey capitalizedString], storedResourceTypeQuantity];
		cell = storedResourceCell;
	} else {
		LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		emptyCell.label.text = @"Resources";
		emptyCell.content.text = @"None";
		cell = emptyCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedStoredResourceTypeKey = [self.storedResourceTypeKeys objectAtIndex:indexPath.row];
	NSDecimalNumber *storedResourceTypeQuantity = [Util asNumber:[self.storedResourceTypes objectForKey:self.selectedStoredResourceTypeKey]];
	self->pickNumericValueController = [[PickNumericValueController createWithDelegate:self maxValue:storedResourceTypeQuantity hidesZero:NO showTenths:NO] retain];
	[self presentViewController:self->pickNumericValueController animated:YES completion:nil];
	self->pickNumericValueController.titleLabel.text = [self.selectedStoredResourceTypeKey capitalizedString];
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
	self.storedResourceTypes = nil;
	self.storedResourceTypeKeys = nil;
	self.selectedStoredResourceTypeKey = nil;
	[self->pickNumericValueController release];
    [super dealloc];
}


#pragma mark -
#pragma mark PickNumericValueControllerDelegate Methods

- (void)newNumericValue:(NSDecimalNumber *)value {
	[self.delegate selectedStoredResourceType:self.selectedStoredResourceTypeKey amount:value];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectResourceTypeFromListController *)create {
	return [[[SelectResourceTypeFromListController alloc] init] autorelease];
}


@end

