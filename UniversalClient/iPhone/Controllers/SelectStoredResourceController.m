//
//  SelectStoredResource.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/18/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectStoredResourceController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BaseTradeBuilding.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"


@implementation SelectStoredResourceController


@synthesize baseTradeBuilding;
@synthesize selectedStoredResource;
@synthesize delegate;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Resource";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.baseTradeBuilding addObserver:self forKeyPath:@"storedResources" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.baseTradeBuilding.storedResources) {
		[self.baseTradeBuilding loadTradeableStoredResources];
	} else {
		[self.baseTradeBuilding.storedResources sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease])];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.baseTradeBuilding removeObserver:self forKeyPath:@"storedResources"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.baseTradeBuilding && self.baseTradeBuilding.storedResources) {
		if ([self.baseTradeBuilding.storedResources count] > 0) {
			return [self.baseTradeBuilding.storedResources count];
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.baseTradeBuilding && self.baseTradeBuilding.storedResources) {
		if ([self.baseTradeBuilding.storedResources count] > 0) {
			return [LETableViewCellButton getHeightForTableView:tableView];
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
	
	if (self.baseTradeBuilding && self.baseTradeBuilding.storedResources) {
		if ([self.baseTradeBuilding.storedResources count] > 0) {
			NSMutableDictionary *storedResource = [self.baseTradeBuilding.storedResources objectAtIndex:indexPath.row];
			LETableViewCellButton *storedResourceCell = [LETableViewCellButton getCellForTableView:tableView];
			storedResourceCell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", [[storedResource objectForKey:@"type"] capitalizedString], [storedResource objectForKey:@"quantity"]];
			cell = storedResourceCell;
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Resources";
			emptyCell.content.text = @"None";
			cell = emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Resources";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedStoredResource = [self.baseTradeBuilding.storedResources objectAtIndex:indexPath.row];
	NSDecimalNumber *max = [Util asNumber:[self.selectedStoredResource objectForKey:@"quantity"]];
	if (self.baseTradeBuilding.maxCargoSize) {
		if ([max compare:self.baseTradeBuilding.maxCargoSize] == NSOrderedDescending) {
			max = self.baseTradeBuilding.maxCargoSize;
		}
	}
	self->pickNumericValueController = [[PickNumericValueController createWithDelegate:self maxValue:max hidesZero:NO showTenths:NO] retain];
	[self presentViewController:self->pickNumericValueController animated:YES completion:nil];
	self->pickNumericValueController.titleLabel.text = [[self.selectedStoredResource objectForKey:@"type"] capitalizedString];
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
	self.selectedStoredResource = nil;
	[self->pickNumericValueController release];
    [super dealloc];
}


#pragma mark -
#pragma mark PickNumericValueControllerDelegate Methods

- (void)newNumericValue:(NSDecimalNumber *)value {
	NSMutableDictionary *selected = _dict([self.selectedStoredResource objectForKey:@"type"], @"type", value, @"quantity");
	[self.delegate storedResourceSelected:selected];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectStoredResourceController *)create {
	return [[[SelectStoredResourceController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"storedResources"]) {
		[self.baseTradeBuilding.storedResources sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES] autorelease])];
		[self.tableView reloadData];
	}
}


@end

