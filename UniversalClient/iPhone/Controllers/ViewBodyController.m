//
//  ViewBodyController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewBodyController.h"
#import "LEMacros.h"
#import "Session.h"
#import "LEGetBody.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellBody.h"
#import "LETableViewCellCurrentResources.h"
#import "ViewBodyMapController.h"


typedef enum {
	SECTION_BODY_OVERVIEW,
	SECTION_ACTIONS,
	SECTION_COMPOSITION
} SECTION;


typedef enum {
	BODY_OVERVIEW_ROW_NAME,
	BODY_OVERVIEW_ROW_PRODUCTION
} BODY_OVERVIEW_ROW;


typedef enum {
	ACTION_ROW_VIEW_BUILDINGS,
	ACTION_ROW_RENAME_BODY
} ACTION_ROW;

typedef enum {
	COMPOSITION_ROW_SIZE,
	COMPOSITION_ROW_ANTHRACITE,
	COMPOSITION_ROW_BAUXITE,
	COMPOSITION_ROW_BERYL,
	COMPOSITION_ROW_CHALCOPYRITE,
	COMPOSITION_ROW_CHROMITE,
	COMPOSITION_ROW_FLUORITE,
	COMPOSITION_ROW_GALENA,
	COMPOSITION_ROW_GOETHITE,
	COMPOSITION_ROW_GOLD,
	COMPOSITION_ROW_GYPSUM,
	COMPOSITION_ROW_HALITE,
	COMPOSITION_ROW_KEROGEN,
	COMPOSITION_ROW_MAGNETITE,
	COMPOSITION_ROW_METHANE,
	COMPOSITION_ROW_MONAZITE,
	COMPOSITION_ROW_RUTILE,
	COMPOSITION_ROW_SULFUR,
	COMPOSITION_ROW_TRONA,
	COMPOSITION_ROW_URANINITE,
	COMPOSITION_ROW_ZIRCON,
	COMPOSITION_ROW_WATER
} COMPOSITION_ROW;


@implementation ViewBodyController


@synthesize bodyId;
@synthesize	bodyData;
@synthesize timer;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	//Duplicated in case loaded from Nib instead of create
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = LE_BLUE;
	
	self.navigationItem.title = @"Loading";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];

	self.sectionHeaders = array_([LEViewSectionTab tableView:self.tableView createWithText:@"Body"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Actions"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Composition"]);
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	Session *session = [Session sharedInstance];
	if (self.bodyData) {
		self.bodyId = [self.bodyData objectForKey:@"id"];
		self.navigationItem.title = [self.bodyData objectForKey:@"name"];
	} else {
		if (!self.bodyId) {
			self.bodyId = [session.empireData objectForKey:@"home_planet_id"];
		}
		
		self.navigationItem.title = @"Loading";
	}
	
	[[LEGetBody alloc] initWithCallback:@selector(bodyDataLoaded:) target:self bodyId:self.bodyId];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.timer invalidate];
	self.timer = nil;
}

 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.bodyData) {
		if (ownBody) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.bodyData) {
		switch (section) {
			case SECTION_BODY_OVERVIEW:
				if (ownBody) {
					return 2;
				} else {
					return 1;
				}
				break;
			case SECTION_ACTIONS:
				return 2;
				break;
			case SECTION_COMPOSITION:
				return 22;
				break;
			default:
				return 0;
				break;
		}
	} else {
		return 0;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_BODY_OVERVIEW:
			switch (indexPath.row) {
				case BODY_OVERVIEW_ROW_NAME:
					return [LETableViewCellBody getHeightForTableView:tableView];
					break;
				default:
					return [LETableViewCellCurrentResources getHeightForTableView:tableView];
					break;
			}
			break;
		case SECTION_ACTIONS:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case SECTION_COMPOSITION:
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		default:
			return 5.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
    
	switch (indexPath.section) {
		case SECTION_BODY_OVERVIEW:
			switch (indexPath.row) {
				case BODY_OVERVIEW_ROW_NAME:
					; //DO NOT REMOVE
					LETableViewCellBody *bodyCell = [LETableViewCellBody getCellForTableView:tableView];
					bodyCell.planetImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"/assets/star_system/%@.png", [self.bodyData objectForKey:@"image"]]];
					bodyCell.planetLabel.text = [self.bodyData objectForKey:@"name"];
					bodyCell.systemLabel.text = [self.bodyData objectForKey:@"star_name"];
					bodyCell.orbitLabel.text = [self.bodyData objectForKey:@"orbit"];
					bodyCell.empireLabel.text = [[self.bodyData objectForKey:@"empire"] objectForKey:@"name"];
					cell = bodyCell;
					break;
				default:
					; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
					LETableViewCellCurrentResources *resourceCell = [LETableViewCellCurrentResources getCellForTableView:tableView];
					[resourceCell setEnergyCurrent:[self.bodyData objectForKey:@"energy_stored"] capacity:[self.bodyData objectForKey:@"energy_capacity"] perHour:[self.bodyData objectForKey:@"energy_hour"]];
					[resourceCell setFoodCurrent:[self.bodyData objectForKey:@"food_stored"] capacity:[self.bodyData objectForKey:@"food_capacity"] perHour:[self.bodyData objectForKey:@"food_hour"]];
					[resourceCell setHappinessCurrent:[self.bodyData objectForKey:@"happiness"] perHour:[self.bodyData objectForKey:@"happiness_hour"]];
					[resourceCell setOreCurrent:[self.bodyData objectForKey:@"ore_stored"] capacity:[self.bodyData objectForKey:@"ore_capacity"] perHour:[self.bodyData objectForKey:@"ore_hour"]];
					[resourceCell setWasteCurrent:[self.bodyData objectForKey:@"waste_stored"] capacity:[self.bodyData objectForKey:@"waste_capacity"] perHour:[self.bodyData objectForKey:@"waste_hour"]];
					[resourceCell setWaterCurrent:[self.bodyData objectForKey:@"water_stored"] capacity:[self.bodyData objectForKey:@"water_capacity"] perHour:[self.bodyData objectForKey:@"water_hour"]];
					cell = resourceCell;
					break;
			}
			break;
		case SECTION_ACTIONS:
			switch (indexPath.row) {
				case ACTION_ROW_VIEW_BUILDINGS:
					; //DO NOT REMOVE
					LETableViewCellButton *viewBuildingsCell = [LETableViewCellButton getCellForTableView:tableView];
					viewBuildingsCell.textLabel.text = @"View Buildings";
					cell = viewBuildingsCell;
					break;
				case ACTION_ROW_RENAME_BODY:
					; //DO NOT REMOVE
					LETableViewCellButton *renameBodyCell = [LETableViewCellButton getCellForTableView:tableView];
					renameBodyCell.textLabel.text = @"Rename Body";
					cell = renameBodyCell;
					break;
				default:
					break;
			}
			break;
		case SECTION_COMPOSITION:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *compositionCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			NSDictionary *ores = [self.bodyData objectForKey:@"ore"];
			switch (indexPath.row) {
				case COMPOSITION_ROW_SIZE:
					compositionCell.label.text = @"Size";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [self.bodyData objectForKey:@"size"]];
					break;
					break;
				case COMPOSITION_ROW_ANTHRACITE:
					compositionCell.label.text = @"Anthracite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"anthracite"]];
					break;
				case COMPOSITION_ROW_BAUXITE:
					compositionCell.label.text = @"Bauxite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"bauxite"]];
					break;
				case COMPOSITION_ROW_BERYL:
					compositionCell.label.text = @"Beryl";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"beryl"]];
					break;
				case COMPOSITION_ROW_CHALCOPYRITE:
					compositionCell.label.text = @"Chalcopyrite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"chalcopyrite"]];
					break;
				case COMPOSITION_ROW_CHROMITE:
					compositionCell.label.text = @"Chromite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"chromite"]];
					break;
				case COMPOSITION_ROW_FLUORITE:
					compositionCell.label.text = @"Fluorite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"fluorite"]];
					break;
				case COMPOSITION_ROW_GALENA:
					compositionCell.label.text = @"Galena";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"galena"]];
					break;
				case COMPOSITION_ROW_GOETHITE:
					compositionCell.label.text = @"Goethite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"goethite"]];
					break;
				case COMPOSITION_ROW_GOLD:
					compositionCell.label.text = @"Gold";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"gold"]];
					break;
				case COMPOSITION_ROW_GYPSUM:
					compositionCell.label.text = @"Gypsum";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"gypsum"]];
					break;
				case COMPOSITION_ROW_HALITE:
					compositionCell.label.text = @"Halite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"halite"]];
					break;
				case COMPOSITION_ROW_KEROGEN:
					compositionCell.label.text = @"Kerogen";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"kerogen"]];
					break;
				case COMPOSITION_ROW_MAGNETITE:
					compositionCell.label.text = @"Magnetite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"magnetite"]];
					break;
				case COMPOSITION_ROW_METHANE:
					compositionCell.label.text = @"Methane";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"methane"]];
					break;
				case COMPOSITION_ROW_MONAZITE:
					compositionCell.label.text = @"Monazite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"monazite"]];
					break;
				case COMPOSITION_ROW_RUTILE:
					compositionCell.label.text = @"Rutile";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"rutile"]];
					break;
				case COMPOSITION_ROW_SULFUR:
					compositionCell.label.text = @"Sulfur";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"sulfur"]];
					break;
				case COMPOSITION_ROW_TRONA:
					compositionCell.label.text = @"Trona";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"trona"]];
					break;
				case COMPOSITION_ROW_URANINITE:
					compositionCell.label.text = @"Uraninite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"uraninite"]];
					break;
				case COMPOSITION_ROW_ZIRCON:
					compositionCell.label.text = @"Zircon";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [ores objectForKey:@"zircon"]];
					break;
				case COMPOSITION_ROW_WATER:
					compositionCell.label.text = @"Water";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [self.bodyData objectForKey:@"water"]];
					break;
				default:
					compositionCell.label.text = @"UNKNOWN";
					break;
			}
			cell = compositionCell;
			break;
		default:
			break;
	}
    
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == SECTION_ACTIONS) {
		switch (indexPath.row) {
			case ACTION_ROW_VIEW_BUILDINGS:
				NSLog(@"Clicked view buildings");
				ViewBodyMapController *viewBodyMapController = [[ViewBodyMapController alloc] init];
				viewBodyMapController.bodyId = self.bodyId;
				viewBodyMapController.bodyName = [self.bodyData objectForKey:@"name"];
				viewBodyMapController.maxBuildings = [self.bodyData objectForKey:@"size"];
				[self.navigationController pushViewController:viewBodyMapController animated:YES];
				[viewBodyMapController release];
				break;
			case ACTION_ROW_RENAME_BODY:
				NSLog(@"Clicked rename body");
				/*
				RenameBodyController *renameBodyController = [[RenameBodyController alloc] initWithNibName:@"RenameBodyController" bundle:nil];
				renameBodyController.bodyId = self.bodyId;
				[[self navigationController] pushViewController:renameBodyController animated:YES];
				[renameBodyController release];
				*/
				break;
			default:
				NSLog(@"Invalid action clicked: %i:%i", indexPath.section, indexPath.row);
				break;
		}
		[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    self.bodyData = nil;
	[self.timer invalidate];
	self.timer = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.bodyId = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (id)bodyDataLoaded:(LEGetBody *)request {
	self.bodyData = request.body;
	
	Session *session = [Session sharedInstance];
	NSString *sessionEmpireId = [session.empireData objectForKey:@"id"];
	NSString *bodyEmpireId = [[self.bodyData objectForKey:@"empire"] objectForKey:@"id"];
	ownBody = [bodyEmpireId isEqualToString:sessionEmpireId];
	
	self.navigationItem.title = [self.bodyData objectForKey:@"name"];
	[self.tableView reloadData];
	
	return nil;
}


- (void)handleTimer:(NSTimer *)theTimer {
	if (theTimer == self.timer) {
		[[LEGetBody alloc] initWithCallback:@selector(bodyDataLoaded:) target:self bodyId:self.bodyId];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (ViewBodyController *)create {
	return [[[ViewBodyController alloc] init] autorelease];
}


@end

