//
//  NewOneForOneTradeController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/21/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewOneForOneTradeController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "BaseTradeBuilding.h"
#import "OneForOneTrade.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "SelectStoredResourceController.h"
#import "SelectResourceTypeController.h"
#import "LEBuildingTradeOneForOne.h"


typedef enum {
	SECTION_HAVE,
	SECTION_WANT
} SECTIONS;


@interface NewOneForOneTradeController (PrivateMethods)

- (void)tradeOneForOne;

@end


@implementation NewOneForOneTradeController


@synthesize baseTradeBuilding;
@synthesize oneForOneTrade;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(send)] autorelease];
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Have"], [LEViewSectionTab tableView:self.tableView withText:@"Want"]);
	
	if (!self.oneForOneTrade) {
		self.oneForOneTrade = [[[OneForOneTrade alloc] init] autorelease];
	}
	[self.baseTradeBuilding clearLoadables];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [LETableViewCellButton getHeightForTableView:tableView];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case SECTION_HAVE:
			; //DO NOT REMOVE
			LETableViewCellButton *haveButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			if (self.oneForOneTrade.haveResourceType) {
				haveButtonCell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", [self.oneForOneTrade.haveResourceType capitalizedString], [Util prettyNSDecimalNumber:self.oneForOneTrade.quantity]];
			} else {
				haveButtonCell.textLabel.text = @"Select Stored Resource";
			}
			cell = haveButtonCell;
			break;
		case SECTION_WANT:
			; //DO NOT REMOVE
			LETableViewCellButton *wantButtonCell = [LETableViewCellButton getCellForTableView:tableView];
			if (self.oneForOneTrade.wantResourceType) {
				wantButtonCell.textLabel.text = [self.oneForOneTrade.wantResourceType capitalizedString];
			} else {
				wantButtonCell.textLabel.text = @"Select Resource Type";
			}
			cell = wantButtonCell;
			break;
	}
	
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_HAVE:
			; //DO NOT REMOVE
			self->selectStoredResourceController = [[SelectStoredResourceController create] retain];
			self->selectStoredResourceController.delegate = self;
			self->selectStoredResourceController.baseTradeBuilding = self.baseTradeBuilding;
			[self.navigationController pushViewController:self->selectStoredResourceController animated:YES];
			break;
		case SECTION_WANT:
			; //DO NOT REMOVE
			self->selectResourceTypeController = [[SelectResourceTypeController create] retain];
			self->selectResourceTypeController.delegate = self;
			self->selectResourceTypeController.baseTradeBuilding = self.baseTradeBuilding;
			[self.navigationController pushViewController:self->selectResourceTypeController animated:YES];
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.baseTradeBuilding = nil;
	self.oneForOneTrade = nil;
	[self->selectStoredResourceController release];
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)send {
	if (self.oneForOneTrade.haveResourceType && self.oneForOneTrade.wantResourceType && (_intv(self.oneForOneTrade.quantity) > 0)) {
		if (self.baseTradeBuilding.usesEssentia) {			
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"This will cost 3 essentia. Do you wish to contine?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
				[self tradeOneForOne];
			}];
			UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
			}];
			[alert addAction:cancelAction];
			[alert addAction:okAction];
			[self presentViewController:alert animated:YES completion:nil];
		} else {
			[self oneForOneTrade];
		}
	} else {
		NSString *errorText;
		if (!self.oneForOneTrade.haveResourceType && !self.oneForOneTrade.wantResourceType) {
			errorText = @"You must select what you have to trade and want to receive.";
		} else if (!self.oneForOneTrade.haveResourceType) {
			errorText = @"You must select what you have to trade.";
		} else if (!self.oneForOneTrade.wantResourceType) {
			errorText = @"You must select what you want to receive.";
		} else if (self.oneForOneTrade.quantity && (_intv(self.oneForOneTrade.quantity) <= 0)) {
			errorText = @"You must select a quantity greater than zero to trade.";
		} else {
			errorText = @"This trade is not valid.";
		}
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Trade invalid" message:errorText preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	}
}


#pragma mark -
#pragma mark SelectStoredResourcesDelegate Methods

- (void)storedResourceSelected:(NSDictionary *)storedResource {
	if (self.oneForOneTrade.haveResourceType && self.oneForOneTrade.quantity) {
		[self.baseTradeBuilding addTradeableStoredResource:_dict(self.oneForOneTrade.haveResourceType, @"type", self.oneForOneTrade.quantity, @"quantity")];
		self.oneForOneTrade.haveResourceType = nil;
		self.oneForOneTrade.quantity = nil;
	}
	self.oneForOneTrade.haveResourceType = [storedResource objectForKey:@"type"];
	self.oneForOneTrade.quantity = [storedResource objectForKey:@"quantity"];
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectStoredResourceController release];
	self->selectStoredResourceController = nil;
	[self.baseTradeBuilding removeTradeableStoredResource:storedResource];
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark SelectStoredResourcesDelegate Methods

- (void)resourceTypeSelected:(NSString *)resourceType withQuantity:(NSDecimalNumber *)quantity {
	self.oneForOneTrade.wantResourceType = resourceType;
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectResourceTypeController release];
	self->selectResourceTypeController = nil;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark PrivateMethods

- (void)tradeOneForOne {
	[self.baseTradeBuilding tradeOneForOne:self.oneForOneTrade target:self callback:@selector(tradedOneForOne:)];
}



#pragma mark -
#pragma mark Callbacks

- (id)tradedOneForOne:(LEBuildingTradeOneForOne *)request {
	if ([request wasError]) {
		NSString *errorText = [request errorMessage];
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Count not do 1 for 1 trade." message:errorText preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		[request markErrorHandled];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (NewOneForOneTradeController *)create {
	return [[[NewOneForOneTradeController alloc] init] autorelease];
}


@end

