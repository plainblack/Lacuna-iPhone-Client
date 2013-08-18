//
//  BuildStashExchangeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/20/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "BuildStashExchangeController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Embassy.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLongLabeledText.h"
#import "LETableViewCellParagraph.h"
#import "SelectResourceTypeFromListController.h"
#import "LEBuildingExchangeWithStash.h"


typedef enum {
	SECTION_DEPOSIT,
	SECTION_WITHDRAW,
	SECTION_STATUS
} SECTION;


@interface BuildStashExchangeController (PrivateMethods)

- (void)generateStatusMessage;

@end


@implementation BuildStashExchangeController


@synthesize embassy;
@synthesize depositeResources;
@synthesize depositeResourceKeys;
@synthesize withdrawResources;
@synthesize withdrawResourceKeys;
@synthesize statusMessage;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Stash Exchange";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Deposit"], [LEViewSectionTab tableView:self.tableView withText:@"Withdraw"], [LEViewSectionTab tableView:self.tableView withText:@"Status"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if (!self.depositeResources) {
		self.depositeResources = [NSMutableDictionary dictionaryWithCapacity:5];
		self.depositeResourceKeys = [NSArray array];
		self.withdrawResources = [NSMutableDictionary dictionaryWithCapacity:5];
		self.withdrawResourceKeys = [NSArray array];
	}
	if (!self.statusMessage) {
		[self generateStatusMessage];
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
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_DEPOSIT:
			return [self.depositeResources count]+1;
			break;
		case SECTION_WITHDRAW:
			return [self.withdrawResources count]+1;
			break;
		case SECTION_STATUS:
			return 1;
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_DEPOSIT:
			if (indexPath.row < [self.depositeResources count]) {
				return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
			} else {
				return [LETableViewCellButton getHeightForTableView:tableView];
			}
			break;
		case SECTION_WITHDRAW:
			if (indexPath.row < [self.withdrawResources count]) {
				return [LETableViewCellLongLabeledText getHeightForTableView:tableView];
			} else {
				return [LETableViewCellButton getHeightForTableView:tableView];
			}
			break;
		case SECTION_STATUS:
			return [LETableViewCellParagraph getHeightForTableView:tableView text:self.statusMessage];
			break;
		default:
			return 0;
			break;
	}
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_DEPOSIT:
			if (indexPath.row < [self.depositeResources count]) {
				NSString *key = [self.depositeResourceKeys objectAtIndex:indexPath.row];
				LETableViewCellLongLabeledText *depositeResourceCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
				depositeResourceCell.label.text = [Util prettyCodeValue:key];
				depositeResourceCell.content.text = [Util prettyNSDecimalNumber:[self.depositeResources objectForKey:key] ];
				return depositeResourceCell;
			} else {
				LETableViewCellButton *depoistAddButton = [LETableViewCellButton getCellForTableView:tableView];
				depoistAddButton.textLabel.text = @"Add";
				return depoistAddButton;
			}
			break;
		case SECTION_WITHDRAW:
			if (indexPath.row < [self.withdrawResources count]) {
				NSString *key = [self.withdrawResourceKeys objectAtIndex:indexPath.row];
				LETableViewCellLongLabeledText *withdrawResourceCell = [LETableViewCellLongLabeledText getCellForTableView:tableView isSelectable:NO];
				withdrawResourceCell.label.text = [Util prettyCodeValue:key];
				withdrawResourceCell.content.text = [Util prettyNSDecimalNumber:[self.withdrawResources objectForKey:key] ];
				return withdrawResourceCell;
			} else {
				LETableViewCellButton *withdrawAddButton = [LETableViewCellButton getCellForTableView:tableView];
				withdrawAddButton.textLabel.text = @"Add";
				return withdrawAddButton;
			}
			break;
		case SECTION_STATUS:
			; //DO NOT REMOVE
			LETableViewCellParagraph *statusCell = [LETableViewCellParagraph getCellForTableView:tableView];
			statusCell.content.text = self.statusMessage;
			return statusCell;
			break;
		default:
			return nil;
			break;
	}
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_DEPOSIT:
			if (indexPath.row >= [self.depositeResources count]) {
				self->addTo = ADD_TO_DEPOSIT;
				SelectResourceTypeFromListController *selectResourceTypeFromListController = [SelectResourceTypeFromListController create];
				selectResourceTypeFromListController.storedResourceTypes = self.embassy.storedResources;
				selectResourceTypeFromListController.delegate = self;
				[self.navigationController pushViewController:selectResourceTypeFromListController animated:YES];
			}
			break;
		case SECTION_WITHDRAW:
			self->addTo = ADD_TO_WITHDRAW;
			if (indexPath.row >= [self.withdrawResources count]) {
				SelectResourceTypeFromListController *selectResourceTypeFromListController = [SelectResourceTypeFromListController create];
				selectResourceTypeFromListController.storedResourceTypes = self.embassy.stash;
				selectResourceTypeFromListController.delegate = self;
				[self.navigationController pushViewController:selectResourceTypeFromListController animated:YES];
			}
			break;
	}
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_DEPOSIT:
			return indexPath.row < [self.depositeResources count];
			break;
		case SECTION_WITHDRAW:
			return indexPath.row < [self.withdrawResources count];
			break;
		default:
			return NO;
			break;
	}
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_DEPOSIT:
			if ( (indexPath.row < [self.depositeResources count]) && (editingStyle == UITableViewCellEditingStyleDelete) ) {
				NSString *type = [self.depositeResourceKeys objectAtIndex:indexPath.row];
				NSDecimalNumber *amount = [self.depositeResources objectForKey:type];
				NSDecimalNumber *oldValue = [self.embassy.storedResources objectForKey:type];
				NSDecimalNumber	*newValue = [oldValue decimalNumberByAdding:amount];
				[self.embassy.storedResources setObject:newValue forKey:type];
				[self.depositeResources removeObjectForKey:type];
				self.depositeResourceKeys = [self.depositeResources keysSortedByValueUsingSelector:@selector(compare:)];
				[tableView reloadData];
			}
			break;
		case SECTION_WITHDRAW:
			if ( (indexPath.row < [self.withdrawResources count]) && (editingStyle == UITableViewCellEditingStyleDelete) ) {
				NSString *type = [self.withdrawResourceKeys objectAtIndex:indexPath.row];
				[self.withdrawResources removeObjectForKey:type];
				self.withdrawResourceKeys = [self.withdrawResources keysSortedByValueUsingSelector:@selector(compare:)];
				[tableView reloadData];
			}
			break;
	}
	[self generateStatusMessage];
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
	self.depositeResources = nil;
	self.depositeResourceKeys = nil;
	self.withdrawResources = nil;
	self.withdrawResourceKeys = nil;
	self.statusMessage = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)cancel {
	[[self navigationController] popViewControllerAnimated:YES];
}


- (void)save {
	[self.embassy stashExchangeDonation:self.depositeResources request:self.withdrawResources target:self callback:@selector(exchanged:)];
}


#pragma mark -
#pragma mark SelectResourceTypeFromListControllerDelegate

- (void)selectedStoredResourceType:(NSString *)type amount:(NSDecimalNumber *)amount {
	switch (self->addTo) {
		case ADD_TO_DEPOSIT:
			; //DO NOT REMOVE
			NSDecimalNumber *depoistAmount = [self.depositeResources objectForKey:type];
			if (depoistAmount) {
				[self.depositeResources setObject:[depoistAmount decimalNumberByAdding:amount] forKey:type];
			} else {
				[self.depositeResources setObject:amount forKey:type];
				self.depositeResourceKeys = [self.depositeResources keysSortedByValueUsingSelector:@selector(compare:)];
			}
			
			NSDecimalNumber *oldValue = [self.embassy.storedResources objectForKey:type];
			NSDecimalNumber *newValue = [oldValue decimalNumberBySubtracting:amount];
			[self.embassy.storedResources setObject:newValue forKey:type];
			break;
		case ADD_TO_WITHDRAW:
			; //DO NOT REMOVE
			NSDecimalNumber *withdrawAmount = [self.withdrawResources objectForKey:type];
			if (withdrawAmount) {
				[self.withdrawResources setObject:[withdrawAmount decimalNumberByAdding:amount] forKey:type];
			} else {
				[self.withdrawResources setObject:amount forKey:type];
				self.withdrawResourceKeys = [self.withdrawResources keysSortedByValueUsingSelector:@selector(compare:)];
			}
			break;
		default:
			NSLog(@"Add To set to invalid value: %i", self->addTo);
			break;
	}

	[self generateStatusMessage];
	[self.navigationController popToViewController:self animated:YES];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Callback Methods

- (void)exchanged:(LEBuildingExchangeWithStash *)request {
	if (![request wasError]) {
		[[self navigationController] popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark PrivateMethods

- (void)generateStatusMessage {
	NSDecimalNumber *depositTotal = [NSDecimalNumber zero];
	NSDecimalNumber *withdrawTotal = [NSDecimalNumber zero];

	for (NSString* type in self.depositeResources) {
		NSDecimalNumber *amount = [self.depositeResources objectForKey:type];
		depositTotal = [depositTotal decimalNumberByAdding:amount];
	}

	for (NSString* type in self.withdrawResources) {
		NSDecimalNumber *amount = [self.withdrawResources objectForKey:type];
		withdrawTotal = [withdrawTotal decimalNumberByAdding:amount];
	}
	
	NSLog(@"depositTotal: %@", depositTotal);
	NSLog(@"withdrawTotal: %@", withdrawTotal);
	switch ([depositTotal compare:withdrawTotal]) {
		case NSOrderedSame:
			if ([depositTotal isEqualToNumber:[NSDecimalNumber zero]]) {
				self.statusMessage = @"Add items to the Deposit and Withdraw for this exchange.";
			} else {
				self.statusMessage = @"Exchange is good.";
			}
			break;
		case NSOrderedAscending:
			self.statusMessage = @"Deposit amount is smaller than Withdraw amount.";
			break;
		case NSOrderedDescending:
			self.statusMessage = @"Withdraw amount is smaller than Deposit amount.";
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark Class Methods

+ (BuildStashExchangeController *)create {
	return [[[BuildStashExchangeController alloc] init] autorelease];
}


@end

