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
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellBody.h"
#import "LETableViewCellCurrentResources.h"
#import "ViewBodyMapController.h"
#import "RenameBodyController.h"


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

	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:@"Body"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Actions"],
								 [LEViewSectionTab tableView:self.tableView createWithText:@"Composition"]);
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	Session *session = [Session sharedInstance];
	if (!self.bodyId) {
		self.bodyId = session.empire.homePlanetId;
	}
	self.navigationItem.title = @"Loading";
	
	[session addObserver:self forKeyPath:@"body" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[session addObserver:self forKeyPath:@"lastTick" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[session loadBody:self.bodyId];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


- (void)viewDidDisappear:(BOOL)animated {
	Session *session = [Session sharedInstance];
	[session removeObserver:self forKeyPath:@"body"];
    [super viewDidDisappear:animated];
}

 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	Session *session = [Session sharedInstance];
	if (session.body) {
		if ([session.body.empireId isEqualToString:session.empire.id]) {
			return 3;
		} else {
			return 1;
		}
	} else {
		return 0;
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	Session *session = [Session sharedInstance];
	if (session.body) {
		switch (section) {
			case SECTION_BODY_OVERVIEW:
				if ([session.body.empireId isEqualToString:session.empire.id]) {
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
	Session *session = [Session sharedInstance];
	UITableViewCell *cell;
    
	switch (indexPath.section) {
		case SECTION_BODY_OVERVIEW:
			switch (indexPath.row) {
				case BODY_OVERVIEW_ROW_NAME:
					; //DO NOT REMOVE
					LETableViewCellBody *bodyCell = [LETableViewCellBody getCellForTableView:tableView];
					bodyCell.planetImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"/assets/star_system/%@.png", session.body.imageName]];
					bodyCell.planetLabel.text = session.body.name;
					bodyCell.systemLabel.text = session.body.starName;
					bodyCell.orbitLabel.text = [NSString stringWithFormat:@"%i", session.body.orbit];
					bodyCell.empireLabel.text = session.body.empireName;
					cell = bodyCell;
					break;
				default:
					; //DON'T REMOVE THIS!! IF YOU DO THIS WON'T COMPILE
					LETableViewCellCurrentResources *resourceCell = [LETableViewCellCurrentResources getCellForTableView:tableView];
					[resourceCell showBodyData:session.body];
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
			switch (indexPath.row) {
				case COMPOSITION_ROW_SIZE:
					compositionCell.label.text = @"Size";
					compositionCell.content.text = [NSString stringWithFormat:@"%i", session.body.size];
					break;
					break;
				case COMPOSITION_ROW_ANTHRACITE:
					compositionCell.label.text = @"Anthracite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"anthracite"]];
					break;
				case COMPOSITION_ROW_BAUXITE:
					compositionCell.label.text = @"Bauxite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"bauxite"]];
					break;
				case COMPOSITION_ROW_BERYL:
					compositionCell.label.text = @"Beryl";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"beryl"]];
					break;
				case COMPOSITION_ROW_CHALCOPYRITE:
					compositionCell.label.text = @"Chalcopyrite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"chalcopyrite"]];
					break;
				case COMPOSITION_ROW_CHROMITE:
					compositionCell.label.text = @"Chromite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"chromite"]];
					break;
				case COMPOSITION_ROW_FLUORITE:
					compositionCell.label.text = @"Fluorite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"fluorite"]];
					break;
				case COMPOSITION_ROW_GALENA:
					compositionCell.label.text = @"Galena";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"galena"]];
					break;
				case COMPOSITION_ROW_GOETHITE:
					compositionCell.label.text = @"Goethite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"goethite"]];
					break;
				case COMPOSITION_ROW_GOLD:
					compositionCell.label.text = @"Gold";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"gold"]];
					break;
				case COMPOSITION_ROW_GYPSUM:
					compositionCell.label.text = @"Gypsum";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"gypsum"]];
					break;
				case COMPOSITION_ROW_HALITE:
					compositionCell.label.text = @"Halite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"halite"]];
					break;
				case COMPOSITION_ROW_KEROGEN:
					compositionCell.label.text = @"Kerogen";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"kerogen"]];
					break;
				case COMPOSITION_ROW_MAGNETITE:
					compositionCell.label.text = @"Magnetite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"magnetite"]];
					break;
				case COMPOSITION_ROW_METHANE:
					compositionCell.label.text = @"Methane";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"methane"]];
					break;
				case COMPOSITION_ROW_MONAZITE:
					compositionCell.label.text = @"Monazite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"monazite"]];
					break;
				case COMPOSITION_ROW_RUTILE:
					compositionCell.label.text = @"Rutile";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"rutile"]];
					break;
				case COMPOSITION_ROW_SULFUR:
					compositionCell.label.text = @"Sulfur";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"sulfur"]];
					break;
				case COMPOSITION_ROW_TRONA:
					compositionCell.label.text = @"Trona";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"trona"]];
					break;
				case COMPOSITION_ROW_URANINITE:
					compositionCell.label.text = @"Uraninite";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"uraninite"]];
					break;
				case COMPOSITION_ROW_ZIRCON:
					compositionCell.label.text = @"Zircon";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", [session.body.ores objectForKey:@"zircon"]];
					break;
				case COMPOSITION_ROW_WATER:
					compositionCell.label.text = @"Water";
					compositionCell.content.text = [NSString stringWithFormat:@"%@", session.body.planetWater];
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
				; //DO NOT REMOVE
				ViewBodyMapController *viewBodyMapController = [[ViewBodyMapController alloc] init];
				[self.navigationController pushViewController:viewBodyMapController animated:YES];
				[viewBodyMapController release];
				break;
			case ACTION_ROW_RENAME_BODY:
				; //DO NOT REMOVE
				Session *session = [Session sharedInstance];
				RenameBodyController *renameBodyController = [RenameBodyController create];
				renameBodyController.bodyId = self.bodyId;
				renameBodyController.nameCell.textField.text = session.body.name;
				[[self navigationController] pushViewController:renameBodyController animated:YES];
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
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


- (void)dealloc {
	self.bodyId = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)clear {
	self.bodyId = nil;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewBodyController *)create {
	return [[[ViewBodyController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"body"]) {
		Session *session = [Session sharedInstance];
		self.navigationItem.title = session.body.name;
		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"lastTick"]) {
		Session *session = [Session sharedInstance];
		self.navigationItem.title = session.body.name;
		[self.tableView reloadData];
	}
}


@end

