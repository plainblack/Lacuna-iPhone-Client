//
//  ViewUniverseMiningPlatformsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewUniverseMiningPlatformsController.h"
#import "Util.h"
#import "Session.h"
#import "LEBuildingGetShipsFor.h"
#import "LETableViewCellLabeledText.h"
#import "ViewPublicEmpireProfileController.h"


@implementation ViewUniverseMiningPlatformsController


@synthesize miningPlatforms;
@synthesize mapItem;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.navigationItem.title = @"Mining Platforms";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	Session *session = [Session sharedInstance];
	if ([self.mapItem.type isEqualToString:@"star"]) {
		[[[LEBuildingGetShipsFor alloc] initWithCallback:@selector(shipsLoaded:) target:self fromBodyId:session.body.id targetBodyName:nil targetBodyId:nil targetStarName:nil targetStarId:self.mapItem.id targetX:nil targetY:nil] autorelease];
	} else {
		[[[LEBuildingGetShipsFor alloc] initWithCallback:@selector(shipsLoaded:) target:self fromBodyId:session.body.id targetBodyName:nil targetBodyId:self.mapItem.id targetStarName:nil targetStarId:nil targetX:nil targetY:nil] autorelease];
	}
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.miningPlatforms) {
		if ([self.miningPlatforms count] > 0) {
			return [self.miningPlatforms count];
		} else {
			return 1;
		}
		
	} else {
		return 1;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.miningPlatforms) {
		if ([self.miningPlatforms count] > 0) {
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
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
	
	if (self.miningPlatforms) {
		if ([self.miningPlatforms count] > 0) {
			NSMutableDictionary *miningPlatform = [self.miningPlatforms objectAtIndex:indexPath.row];
			LETableViewCellLabeledText *miningPlatformCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:YES];
			miningPlatformCell.label.text = @"Owning Empire";
			miningPlatformCell.content.text = [miningPlatform objectForKey:@"empire_name"];
			cell = miningPlatformCell;
		} else {
			LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
			loadingCell.label.text = @"Platforms";
			loadingCell.content.text = @"None";
			cell = loadingCell;
		}
		
	} else {
		LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
		loadingCell.label.text = @"Platforms";
		loadingCell.content.text = @"Loading";
		cell = loadingCell;
	}
    
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.miningPlatforms) {
		if ([self.miningPlatforms count] > 0) {
			NSMutableDictionary *miningPlatform = [self.miningPlatforms objectAtIndex:indexPath.row];
			ViewPublicEmpireProfileController *viewPublicEmpireProfileController = [ViewPublicEmpireProfileController create];
			viewPublicEmpireProfileController.empireId = [miningPlatform objectForKey:@"empire_id"];
			[self.navigationController pushViewController:viewPublicEmpireProfileController animated:YES];
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
	self.miningPlatforms = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.miningPlatforms = nil;
	self.mapItem = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)shipsLoaded:(LEBuildingGetShipsFor *)request {
	self.miningPlatforms = request.miningPlatforms;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Class Methods

+ (ViewUniverseMiningPlatformsController *)create {
	return [[[ViewUniverseMiningPlatformsController alloc] init] autorelease];
}


@end

