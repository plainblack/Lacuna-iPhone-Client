//
//  SelectPlanetToViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectPlanetToViewController.h"
#import "LEMacros.h"
#import "TempleOfTheDrajilites.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "ViewAttachedMapController.h"


@implementation SelectPlanetToViewController


@synthesize templeOfTheDrajilites;
@synthesize planets;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Planet";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.templeOfTheDrajilites addObserver:self forKeyPath:@"viewablePlanets" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.templeOfTheDrajilites addObserver:self forKeyPath:@"planetMap" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.templeOfTheDrajilites loadViewablePlanets];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.templeOfTheDrajilites removeObserver:self forKeyPath:@"planetMap"];
	[self.templeOfTheDrajilites removeObserver:self forKeyPath:@"viewablePlanets"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return MAX([self.planets count], 1);
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.planets) {
		if ([self.planets count] > 0) {
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
	if (self.planets) {
		if ([self.planets count] > 0) {
			NSDictionary *planet = [self.planets objectAtIndex:indexPath.row];
			LETableViewCellButton *planetCell = [LETableViewCellButton getCellForTableView:tableView];
			planetCell.textLabel.text = [planet objectForKey:@"name"];
			return planetCell;
		} else {
			LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			emptyCell.label.text = @"Planets";
			emptyCell.content.text = @"None";
			return emptyCell;
		}
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Planets";
		loadingCell.content.text = @"Loading";
		return loadingCell;
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.planets) {
		if ([self.planets count] > 0) {
			NSDictionary *planet = [self.planets objectAtIndex:indexPath.row];
			[self.templeOfTheDrajilites loadPlanetMap:[planet objectForKey:@"id"]];
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
	self.templeOfTheDrajilites = nil;
	self.planets = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectPlanetToViewController *)create {
	return [[[SelectPlanetToViewController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"viewablePlanets"]) {
		self.planets = self.templeOfTheDrajilites.viewablePlanets;
		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"planetMap"]) {
		ViewAttachedMapController *viewAttachedMapController = [[ViewAttachedMapController alloc] init];
		[viewAttachedMapController setAttachedMap:self.templeOfTheDrajilites.planetMap];
		[self.navigationController pushViewController:viewAttachedMapController animated:YES];
		[viewAttachedMapController release];
	}
}


@end
