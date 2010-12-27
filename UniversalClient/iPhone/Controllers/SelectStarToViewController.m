//
//  SelectStarToViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 12/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "SelectStarToViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "OracleOfAnid.h"
#import "Star.h"
#import "Body.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellStar.h"
#import "LETableViewCellBody.h"
#import "SelectStarController.h"
#import "ViewUniverseItemController.h"


typedef enum {
	SECTION_PICK_STAR,
	SECTION_STAR_SYSTEM
} SECTION;


@implementation SelectStarToViewController


@synthesize oracleOfAnid;
@synthesize starName;
@synthesize starId;
@synthesize star;
@synthesize bodies;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"View Star";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Star to view"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Star System"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (!self.starId) {
		Session *session = [Session sharedInstance];
		self.starId = session.body.starId;
		self.starName = session.body.starName;
	}
	
	[self.oracleOfAnid addObserver:self forKeyPath:@"star" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self.oracleOfAnid loadStar:self.starId];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.oracleOfAnid removeObserver:self forKeyPath:@"star"];
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
		case SECTION_STAR_SYSTEM:
			return MAX(1, [self.bodies count]);
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
		case SECTION_STAR_SYSTEM:
			if (self.star) {
				if (indexPath.row == 0) {
					return [LETableViewCellStar getHeightForTableView:tableView];
				} else {
					return [LETableViewCellBody getHeightForTableView:tableView];
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
		case SECTION_STAR_SYSTEM:
			if (self.star) {
				if (indexPath.row == 0) {
					LETableViewCellStar *starViewCell = [LETableViewCellStar getCellForTableView:tableView isSelectable:YES];
					[starViewCell setStar:self.star];
					return starViewCell;
					/*
					LETableViewCellButton *starViewCell = [LETableViewCellButton getCellForTableView:tableView];
					starViewCell.textLabel.text = self.star.name;
					return starViewCell;
					*/
				} else {
					Body *body = [self.bodies objectAtIndex:(indexPath.row -1 )];
					LETableViewCellBody *bodyViewCell = [LETableViewCellBody getCellForTableView:tableView isSelectable:YES];
					bodyViewCell.planetImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"/assets/star_system/%@.png", body.imageName]];
					bodyViewCell.planetLabel.text = body.name;
					bodyViewCell.systemLabel.text = body.starName;
					bodyViewCell.orbitLabel.text = [NSString stringWithFormat:@"%@", body.orbit];
					bodyViewCell.empireLabel.text = body.empireName;
					return bodyViewCell;
					/*
					Body *body = [self.bodies objectAtIndex:(indexPath.row -1 )];
					LETableViewCellButton *bodyViewCell = [LETableViewCellButton getCellForTableView:tableView];
					bodyViewCell.textLabel.text = body.name;
					return bodyViewCell;
					*/
				}
			} else {
				LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingCell.label.text = @"Star";
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
		case SECTION_STAR_SYSTEM:
			; //DO NOT REMOVE
			ViewUniverseItemController *viewUniverseItemController = [ViewUniverseItemController create];
			if (indexPath.row == 0) {
				viewUniverseItemController.mapItem = self.star;
			} else {
				viewUniverseItemController.mapItem = [self.bodies objectAtIndex:(indexPath.row-1)];
			}
			[self.navigationController pushViewController:viewUniverseItemController animated:YES];
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
	self.oracleOfAnid = nil;
	self.starName = nil;
	self.starId = nil;
	self.star = nil;
	self.bodies = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark SelectStarController

- (void)selectedStar:(NSDictionary *)selectedStar {
	self.starId = [selectedStar objectForKey:@"id"];
	self.starName = [selectedStar objectForKey:@"name"];
	self.star = nil;
	self.bodies = nil;
	[self.oracleOfAnid loadStar:self.starId];
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Class Methods

+ (SelectStarToViewController *)create {
	return [[[SelectStarToViewController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"star"]) {
		self.star = self.oracleOfAnid.star;
		self.bodies = self.oracleOfAnid.bodies;
		[self.tableView reloadData];
	}
}


@end

