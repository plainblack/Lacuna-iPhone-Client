//
//  NewBuildingController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "NewBuildingController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "BuildingUtil.h"
#import "LEBodyMapCell.h"
#import "MapBuilding.h"
#import "LETableViewCellBuildingStats.h"
#import "LETableViewCellCost.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellUnbuildable.h"
#import "LETableViewCellParagraph.h"
#import "LEGetBuildables.h"
#import "LEBuildBuilding.h"
#import "LEViewSectionTab.h"
#import "WebPageController.h"


typedef enum {
	ROW_BUILDING_STATS,
	ROW_COST,
	ROW_DESCRIPTION,
	ROW_WIKI,
	ROW_BUILD
} ROW;

@implementation NewBuildingController


@synthesize listChooser;
@synthesize buttonsByLoc;
@synthesize bodyId;
@synthesize buildables;
@synthesize allBuildings;
@synthesize buildableBuildings;
@synthesize x;
@synthesize y;
@synthesize leGetBuildables;
@synthesize tag;
@synthesize selectedBuildingUrl;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.listChooser = [[[UISegmentedControl alloc] initWithItems:_array(@"Buildable", @"All")] autorelease];
	[self.listChooser addTarget:self action:@selector(switchList) forControlEvents:UIControlEventValueChanged];
	self.listChooser.selectedSegmentIndex = 0;
	self.navigationItem.titleView = self.listChooser;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.leGetBuildables = [[[LEGetBuildables alloc] initWithCallback:@selector(buildableLoaded:) target:self bodyId:self.bodyId x:x y:y tag:tag] autorelease];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.buildables count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *building = [self.buildables objectAtIndex:indexPath.section];
	switch (indexPath.row) {
		case ROW_BUILDING_STATS:
			return [LETableViewCellBuildingStats getHeightForTableView:tableView];
			break;
		case ROW_COST:
			return [LETableViewCellCost getHeightForTableView:tableView];
			break;
		case ROW_DESCRIPTION:
			; //DO NOT REMOVE
			Session *session = [Session sharedInstance];
			return [LETableViewCellParagraph getHeightForTableView:tableView text:[session descriptionForBuilding:[building objectForKey:@"url"]]];
			break;
		case ROW_WIKI:
			return [LETableViewCellButton getHeightForTableView:tableView];
			break;
		case ROW_BUILD:
			; //DO NOT REMOVE
			NSDictionary *build = [building objectForKey:@"build"];
			BOOL canBuild = [[build objectForKey:@"can"] boolValue];
			if (canBuild) {
				return [LETableViewCellButton getHeightForTableView:tableView];
			} else {
				return [LETableViewCellUnbuildable getHeightForTableView:tableView];
			}
			break;
		default:
			return 5;
			break;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *building = [self.buildables objectAtIndex:indexPath.section];
	NSDictionary *build = [building objectForKey:@"build"];
    UITableViewCell *cell = nil;
	Session *session = [Session sharedInstance];

	switch (indexPath.row) {
		case ROW_BUILDING_STATS:
			; //DO NOT REMOVE
			NSDictionary *stats = [building objectForKey:@"production"];
			LETableViewCellBuildingStats *buildingStatsCell = [LETableViewCellBuildingStats getCellForTableView:tableView];
			[buildingStatsCell setBuildingImage:[UIImage imageNamed:[NSString stringWithFormat:@"/assets/planet_side/100/%@.png", [building objectForKey:@"image"]]]];
			[buildingStatsCell setBuildingBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"assets/planet_side/%@.jpg", session.body.surfaceImageName]]];
			[buildingStatsCell setBuildingLevel:[NSDecimalNumber one]];
			[buildingStatsCell setEnergyPerHour:[Util asNumber:[stats objectForKey:@"energy_hour"]]];
			[buildingStatsCell setFoodPerHour:[Util asNumber:[stats objectForKey:@"food_hour"]]];
			[buildingStatsCell setHappinessPerHour:[Util asNumber:[stats objectForKey:@"happiness_hour"]]];
			[buildingStatsCell setOrePerHour:[Util asNumber:[stats objectForKey:@"ore_hour"]]];
			[buildingStatsCell setWastePerHour:[Util asNumber:[stats objectForKey:@"waste_hour"]]];
			[buildingStatsCell setWaterPerHour:[Util asNumber:[stats objectForKey:@"water_hour"]]];
			cell = buildingStatsCell;
			break;
		case ROW_COST:
			; //DO NOT REMOVE
			NSDictionary *cost = [build objectForKey:@"cost"];
			LETableViewCellCost *costCell = [LETableViewCellCost getCellForTableView:tableView];
			[costCell setEnergyCost:[Util asNumber:[cost objectForKey:@"energy"]]];
			[costCell setFoodCost:[Util asNumber:[cost objectForKey:@"food"]]];
			[costCell setOreCost:[Util asNumber:[cost objectForKey:@"ore"]]];
			[costCell setTimeCost:[Util asNumber:[cost objectForKey:@"time"]]];
			[costCell setWasteCost:[Util asNumber:[cost objectForKey:@"waste"]]];
			[costCell setWaterCost:[Util asNumber:[cost objectForKey:@"water"]]];
			cell = costCell;
			break;
		case ROW_DESCRIPTION:
			; //DO NOT REMOVE
			NSDictionary *building = [self.buildables objectAtIndex:indexPath.section];
			Session *session = [Session sharedInstance];
			NSString *description = [session descriptionForBuilding:[building objectForKey:@"url"]];
			LETableViewCellParagraph *descriptionCell = [LETableViewCellParagraph getCellForTableView:tableView];
			descriptionCell.content.text = description;
			cell = descriptionCell;
			break;
		case ROW_WIKI:
			; //DO NOT REMOVE
			LETableViewCellButton *wikiCell = [LETableViewCellButton getCellForTableView:tableView];
			wikiCell.textLabel.text = @"View Wiki Page";
			cell = wikiCell;
			break;
		case ROW_BUILD:
			; //DO NOT REMOVE
			BOOL canBuild = [[build objectForKey:@"can"] boolValue];
			if (canBuild) {
				LETableViewCellButton *buildCell = [LETableViewCellButton getCellForTableView:tableView];
				buildCell.textLabel.text = @"Build";
				cell = buildCell;
			} else {
				LETableViewCellUnbuildable *unbuildableCell = [LETableViewCellUnbuildable getCellForTableView:tableView];
				id reason = [build objectForKey:@"reason"];
				if ([reason isKindOfClass:[NSArray class]]) {
					[unbuildableCell setReason:[NSString stringWithFormat:@"%@", [reason objectAtIndex:1]]];
				} else {
					[unbuildableCell setReason:[NSString stringWithFormat:@"%@", reason]];
				}
				cell = unbuildableCell;
			}
			break;
		default:
			cell = nil;
			break;
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == ROW_WIKI) {
		NSDictionary *building = [self.buildables objectAtIndex:indexPath.section];
		Session *session = [Session sharedInstance];
		NSString *url = [session wikiLinkForBuilding:[building objectForKey:@"url"]];
		WebPageController *webPageController = [WebPageController create];
		webPageController.urlToLoad = url;
		[self presentViewController:webPageController animated:YES completion:nil];
	} else if (indexPath.row == ROW_BUILD) {
		selectedBuilding = indexPath.section;
		NSDictionary *building = [self.buildables objectAtIndex:selectedBuilding];
		NSString *url = [building objectForKey:@"url"];
		Session *session = [Session sharedInstance];
		if (session.empire.isIsolationist && ([url isEqualToString:ESPIONAGE_URL] || [url isEqualToString:MUNITIONS_LAB_URL])) {
			self.selectedBuildingUrl = url;
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Building this will take you out of Isolationist mode. This means spies can be sent to your Colonies. Are you sure you want to do this?" preferredStyle:UIAlertControllerStyleAlert];
			UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
				[[[LEBuildBuilding alloc] initWithCallback:@selector(buildingBuilt:) target:self bodyId:self.bodyId x:self.x y:self.y url:self.selectedBuildingUrl] autorelease];
				self.selectedBuildingUrl = nil;
			}];
			UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
			}];
			[alert addAction:cancelAction];
			[alert addAction:okAction];
			[self presentViewController:alert animated:YES completion:nil];
			
		} else {
			[[[LEBuildBuilding alloc] initWithCallback:@selector(buildingBuilt:) target:self bodyId:self.bodyId x:self.x y:self.y url:url] autorelease];
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
	self.listChooser = nil;
	self.bodyId = nil;
	self.buildables = nil;
	self.allBuildings = nil;
	self.buildableBuildings = nil;
	self.x = nil;
	self.y = nil;
	self.buttonsByLoc = nil;
	[self.leGetBuildables cancel];
	self.leGetBuildables = nil;
	self.tag = nil;
	self.selectedBuildingUrl = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	self.listChooser = nil;
	self.bodyId = nil;
	self.buildables = nil;
	self.allBuildings = nil;
	self.buildableBuildings = nil;
	self.x = nil;
	self.y = nil;
	self.buttonsByLoc = nil;
	[self.leGetBuildables cancel];
	self.leGetBuildables = nil;
	self.tag = nil;
	self.selectedBuildingUrl = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (IBAction)switchList {
	if (self.listChooser.selectedSegmentIndex == 0) {
		self.buildables = self.buildableBuildings;
	} else if (self.listChooser.selectedSegmentIndex == 1) {
		self.buildables = self.allBuildings;
	} else if (self.listChooser.selectedSegmentIndex == 2) {
		self.buildables = [NSArray array];
	}
	
	NSMutableArray *tmpSectionHeaders = [NSMutableArray arrayWithCapacity:[self.buildables count]];
	for (NSDictionary *buildable in self.buildables) {
		[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView withText:[buildable objectForKey:@"name"]]];
	}
	self.sectionHeaders = tmpSectionHeaders;

	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Callbacks


- (id)buildableLoaded:(LEGetBuildables *)request {
	self.allBuildings = request.buildables;
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"build.can = 1"];
	self.buildableBuildings = [request.buildables filteredArrayUsingPredicate:predicate];
	
	if (self.listChooser.selectedSegmentIndex == 0) {
		self.buildables = self.buildableBuildings;
	} else if (self.listChooser.selectedSegmentIndex == 1) {
		self.buildables = self.allBuildings;
	} else if (self.listChooser.selectedSegmentIndex == 2) {
		self.buildables = [NSArray array];
	}
	
	
	NSMutableArray *tmpSectionHeaders = [NSMutableArray arrayWithCapacity:[self.buildables count]];
	for (NSDictionary *buildable in self.buildables) {
		[tmpSectionHeaders addObject:[LEViewSectionTab tableView:self.tableView withText:[buildable objectForKey:@"name"]]];
	}
	self.sectionHeaders = tmpSectionHeaders;
	
	[self.tableView reloadData];
	
	if (!request.buildQueueHasSpace) {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Warning" message: @"Your build queue is full. You must wait for another building to complete. Building/Upgrading your Development Ministery allows you to have more buildings in your queue." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	}

	self.leGetBuildables = nil;
	return nil;
}


- (id)buildingBuilt:(LEBuildBuilding *)request {
	if (![request wasError]) {
		NSDictionary *buildingBuilding = [self.buildables objectAtIndex:selectedBuilding];
		NSString *image = [buildingBuilding objectForKey:@"image"];
		NSString *name = [buildingBuilding objectForKey:@"name"];
		NSString *url = [buildingBuilding objectForKey:@"url"];
		NSMutableDictionary *building = [NSMutableDictionary dictionaryWithCapacity:7];
		[building setObject:request.buildingId forKey:@"id"];
		[building setObject:name forKey:@"name"];
		[building setObject:self.x forKey: @"x"];
		[building setObject:self.y forKey:@"y"];
		[building setObject:url forKey:@"url"];
		[building setObject:[NSDecimalNumber numberWithInt:0] forKey:@"level"];
		[building setObject:image forKey:@"image"];
		[building setObject:[NSDecimalNumber decimalNumberWithString:@"100"] forKey:@"efficiency"];
		[building setObject:[request.building objectForKey:@"pending_build"] forKey:@"pending_build"];
		
		NSString *loc = [NSString stringWithFormat:@"%@x%@", self.x, self.y];
		LEBodyMapCell *mapCell = [self.buttonsByLoc objectForKey:loc];

		if (mapCell) {
			if (!mapCell.mapBuilding) {
				mapCell.mapBuilding = [[[MapBuilding alloc] init] autorelease];
				Session *session = [Session sharedInstance];
				[session.body.buildingMap setObject:mapCell.mapBuilding forKey:loc];
				session.body.buildingCount = [session.body.buildingCount decimalNumberByAdding:[NSDecimalNumber one]];
			}
			[mapCell.mapBuilding parseData:building];
		}
		[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-3)] animated:YES];
	}
	
	return nil;
}


#pragma mark -
#pragma mark Class Methods

+ (NewBuildingController *)create {
	return [[[NewBuildingController alloc] init] autorelease];
}


@end

