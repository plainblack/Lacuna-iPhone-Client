//
//  SelectPlanetToViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectPlanetToViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "TempleOfTheDrajilites.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "SelectStarController.h"
#import "ViewAttachedMapController.h"


typedef enum {
	SECTION_PICK_STAR,
	SECTION_PLANETS
} SECTION;


@implementation SelectPlanetToViewController


@synthesize templeOfTheDrajilites;
@synthesize starName;
@synthesize starId;
@synthesize planets;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Select Planet";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Star to view"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Planets"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (!self.starId) {
		Session *session = [Session sharedInstance];
		self.starId = session.body.starId;
		self.starName = session.body.starName;
	}

	[self.templeOfTheDrajilites addObserver:self forKeyPath:@"viewablePlanets" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.templeOfTheDrajilites addObserver:self forKeyPath:@"planetMap" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.templeOfTheDrajilites loadViewablePlanetsForStar:self.starId];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.templeOfTheDrajilites removeObserver:self forKeyPath:@"planetMap"];
	[self.templeOfTheDrajilites removeObserver:self forKeyPath:@"viewablePlanets"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_PICK_STAR:
			return 1;
			break;
		case SECTION_PLANETS:
			return MAX([self.planets count], 1);
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_PICK_STAR:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case SECTION_PLANETS:
			if (self.planets) {
				if ([self.planets count] > 0) {
					return [LETableViewCellButton getHeightForTableView:tableView];
				} else {
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
				}
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
			break;
		default:
			return 0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_PICK_STAR:
			; // DO NOT REMOVE
			LETableViewCellButton *starCell = [LETableViewCellButton getCellForTableView:tableView];
			starCell.textLabel.text = self.starName;
			return starCell;
			break;
		case SECTION_PLANETS:
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
			break;
		default:
			return nil;
			break;
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_PICK_STAR:
			;// DO NOT REMOVE
			SelectStarController *selectStarController = [SelectStarController create];
			selectStarController.delegate = self;
			[self.navigationController pushViewController:selectStarController animated:YES];
			break;
		case SECTION_PLANETS:
			if (self.planets) {
				if ([self.planets count] > 0) {
					NSDictionary *planet = [self.planets objectAtIndex:indexPath.row];
					[self.templeOfTheDrajilites loadPlanetMap:[planet objectForKey:@"id"]];
				}
			}
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
	self.templeOfTheDrajilites = nil;
	self.starName = nil;
	self.starId = nil;
	self.planets = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark SelectStarController

- (void)selectedStar:(NSDictionary *)star {
	self.starId = [star objectForKey:@"id"];
	self.starName = [star objectForKey:@"name"];
	self.planets = nil;
	[self.navigationController popViewControllerAnimated:YES];
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
