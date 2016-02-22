//
//  ViewMiningPlatformsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 8/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMiningPlatformsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "MiningMinistry.h"
#import "MiningPlatform.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellMiningPlatform.h"
#import "LETableViewCellButton.h"
#import "ViewDictionaryController.h"


typedef enum {
	ROW_PLATFORM_INFO,
	ROW_ORE_COMPOSITION,
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
			return 3;
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
			switch (indexPath.row) {
				case ROW_PLATFORM_INFO:
					return [LETableViewCellMiningPlatform getHeightForTableView:tableView];
					break;
				case ROW_ORE_COMPOSITION:
					return [LETableViewCellButton getHeightForTableView:tableView];
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
	UITableViewCell *cell = nil;
	
	if (self.miningMinistry && self.miningMinistry.platforms) {
		if ([self.miningMinistry.platforms count] > 0) {
			MiningPlatform *miningPlatform = [self.miningMinistry.platforms objectAtIndex:indexPath.section];
			switch (indexPath.row) {
				case ROW_PLATFORM_INFO:
					; //DO NOT REMOVE
					LETableViewCellMiningPlatform *miningPlatformCell = [LETableViewCellMiningPlatform getCellForTableView:tableView];
					[miningPlatformCell setMiningPlatform:miningPlatform];
					cell = miningPlatformCell;
					break;
				case ROW_ORE_COMPOSITION:
					; //DO NOT REMOVE
					LETableViewCellButton *oreCompositionCell = [LETableViewCellButton getCellForTableView:tableView];
					oreCompositionCell.textLabel.text = @"View Ore Types";
					cell = oreCompositionCell;
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
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"Platforms";
			loadingCell.content.text = @"None";
			cell = loadingCell;
		}
		
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
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
				case ROW_ORE_COMPOSITION:
					; //DO NOT REMOVE
					ViewDictionaryController *viewDictionaryController = [ViewDictionaryController createWithName:@"Ore By Type" useLongLabels:NO icon:ORE_ICON];
					viewDictionaryController.data = miningPlatform.oresPerHour;
					[self.navigationController pushViewController:viewDictionaryController animated:YES];
					break;
				case ROW_ABANDON_PLATFORM:
					self.selectedMiningPlatform = miningPlatform;
					
					UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Abandon Platform %@?", miningPlatform.asteroidName] message:@"MESSAGE" preferredStyle:UIAlertControllerStyleAlert];
					UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
						[self.miningMinistry abandonPlatformAtAsteroid:self.selectedMiningPlatform];
						self.selectedMiningPlatform = nil;
					}];
					UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
					}];
					[alert addAction:cancelAction];
					[alert addAction:okAction];
					[self presentViewController:alert animated:YES completion:nil];
					
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.miningMinistry = nil;
	self.selectedMiningPlatform = nil;
    [super dealloc];
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

