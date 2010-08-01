//
//  ViewMiningPlatformsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMiningPlatformsController.h"
#import "Util.h"
#import "MiningMinistry.h"
#import "MiningPlatform.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellDictionary.h"
#import "LETableViewCellButton.h"


typedef enum {
	ROW_PLATFORM_LOCATION,
	ROW_PRODUCTION_CAPACITY,
	ROW_SHIPPING_CAPACTITY,
	ROW_ORE_PER_HOUR,
	ROW_ABANDON_PLATFORM
} ROW;


@implementation ViewMiningPlatformsController


@synthesize miningMinistry;
@synthesize selectedMiningPlatform;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Platforms";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.miningMinistry addObserver:self forKeyPath:@"platforms" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.miningMinistry loadPlatforms];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.miningMinistry removeObserver:self forKeyPath:@"platforms"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.miningMinistry && self.miningMinistry.platforms) {
		if ([self.miningMinistry.platforms count] > 0) {
			return [self.miningMinistry.platforms count];
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.miningMinistry && self.miningMinistry.platforms) {
		if ([self.miningMinistry.platforms count] > 0) {
			return 2;
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.miningMinistry && self.miningMinistry.platforms) {
		if ([self.miningMinistry.platforms count] > 0) {
			MiningPlatform *miningPlatform = [self.miningMinistry.platforms objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_PLATFORM_LOCATION:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_PRODUCTION_CAPACITY:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_SHIPPING_CAPACTITY:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
				case ROW_ORE_PER_HOUR:
					return [LETableViewCellDictionary getHeightForTableView:tableView numItems:[miningPlatform.oresPerHour count]];
					break;
				case ROW_ABANDON_PLATFORM:
					return [LETableViewCellButton getHeightForTableView:tableView];
					break;
				default:
					return tableView.rowHeight;
					break;
			}
		} else {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
		}
		
	} else {
		return [LETableViewCellLabeledText getHeightForTableView:tableView];
	}
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	if (self.miningMinistry && self.miningMinistry.platforms) {
		if ([self.miningMinistry.platforms count] > 0) {
			MiningPlatform *miningPlatform = [self.miningMinistry.platforms objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_PLATFORM_LOCATION:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *locationCell = [LETableViewCellLabeledText getCellForTableView:tableView];
					locationCell.label.text = @"Asteroid";
					locationCell.content.text = miningPlatform.asteroidName;
					cell = locationCell;
					break;
				case ROW_PRODUCTION_CAPACITY:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *productionCapacityCell = [LETableViewCellLabeledText getCellForTableView:tableView];
					productionCapacityCell.label.text = @"Production";
					productionCapacityCell.content.text = [NSString stringWithFormat:@"%i%", miningPlatform.productionCapacity];
					cell = productionCapacityCell;
					break;
				case ROW_SHIPPING_CAPACTITY:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *shippingCapacityCell = [LETableViewCellLabeledText getCellForTableView:tableView];
					shippingCapacityCell.label.text = @"Shipping";
					shippingCapacityCell.content.text = [NSString stringWithFormat:@"%i%", miningPlatform.shippingCapacity];
					cell = shippingCapacityCell;
					break;
				case ROW_ORE_PER_HOUR:
					; //DO NOT REMOVE
					LETableViewCellDictionary *oresPerHourCell = [LETableViewCellDictionary getCellForTableView:tableView];
					[oresPerHourCell setHeading:@"Ore Per Hour" Data:miningPlatform.oresPerHour];
					cell = oresPerHourCell;
					break;
				case ROW_ABANDON_PLATFORM:
					; //DO NOT REMOVE
					LETableViewCellButton *abandonCell = [LETableViewCellButton getCellForTableView:tableView];
					abandonCell.textLabel.text = @"Abandon";
					cell = abandonCell;
					break;
				default:
					cell = nil;
					break;
			}
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			loadingCell.label.text = @"Platforms";
			loadingCell.content.text = @"None";
			cell = loadingCell;
		}
		
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView];
		loadingCell.label.text = @"";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.miningMinistry && self.miningMinistry.platforms) {
		if ([self.miningMinistry.platforms count] > 0) {
			MiningPlatform *miningPlatform = [self.miningMinistry.platforms objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_ABANDON_PLATFORM:
					self.selectedMiningPlatform = miningPlatform;
					UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Abandon Platform %@?", miningPlatform.asteroidName] delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
					actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
					[actionSheet showFromTabBar:self.tabBarController.tabBar];
					[actionSheet release];
					break;
			}
		}
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.miningMinistry = nil;
	self.selectedMiningPlatform = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[self.miningMinistry abandonPlatformAtAsteroid:self.selectedMiningPlatform.asteroidId];
		self.selectedMiningPlatform = nil;
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (ViewMiningPlatformsController *)create {
	return [[[ViewMiningPlatformsController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"platforms"]) {
		[self.tableView reloadData];
	}
}


@end

