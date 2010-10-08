//
//  ViewBodyController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewBodyController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellLabeledIconText.h"
#import "LETableViewCellBody.h"
#import "LETableViewCellCurrentResources.h"
#import "ViewBodyMapControllerV2.h"
#import "RenameBodyController.h"
#import "PickColonyController.h"
#import "ViewCreditsController.h"
#import "LEBodyAbandon.h"


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
	ACTION_ROW_RENAME_BODY,
	ACTION_ROW_ABANDON_BODY
} ACTION_ROW;

typedef enum {
	COMPOSITION_ROW_SIZE,
	COMPOSITION_ROW_WATER
} COMPOSITION_ROW;

	
@interface ViewBodyController (PrivateMethods)

- (void)loadBody;
- (void)pickColony;

@end


@implementation ViewBodyController


@synthesize pageSegmentedControl;
@synthesize bodyId;
@synthesize watchedBody;
@synthesize oreKeysSorted;
@synthesize reloadTimer;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	//Duplicated in case loaded from Nib instead of create
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.separatorColor = SEPARATOR_COLOR;
	
	self.navigationItem.title = @"Loading";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	if ([self.navigationController.viewControllers objectAtIndex:0] == self) {
		self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
	}
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Body"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Actions"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Composition"]);
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	Session *session = [Session sharedInstance];
	if (!self.bodyId) {
		self.bodyId = session.empire.homePlanetId;
	}
	
	self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];

	if ([session.empire.planets count] > 1) {
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStylePlain target:self action:@selector(pickColony)] autorelease];
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}

	self->watchingSession = YES;
	[session addObserver:self forKeyPath:@"body" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[session addObserver:self forKeyPath:@"lastTick" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];

	if (isNotNull(session.body)) {
		[session.body addObserver:self forKeyPath:@"needsRefresh" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
		self.watchedBody = session.body;
		self.oreKeysSorted = [[session.body.ores allKeys] sortedArrayUsingSelector:@selector(compare:)];
	}

	if (![session.body.id isEqualToString:self.bodyId]) {
		self.navigationItem.title = @"Loading";
		[self loadBody];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	if (self.watchedBody) {
		self.navigationItem.title = self.watchedBody.name;
	}
	[self.tableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


- (void)viewDidDisappear:(BOOL)animated {
	[self.reloadTimer invalidate];
	self.reloadTimer = nil;
	Session *session = [Session sharedInstance];
	if (self->watchingSession) {
		[session removeObserver:self forKeyPath:@"body"];
		[session removeObserver:self forKeyPath:@"lastTick"];
		self->watchingSession = NO;
	}
	if (isNotNull(self.watchedBody)) {
		[self.watchedBody removeObserver:self forKeyPath:@"needsRefresh"];
		self.watchedBody = nil;
		self.oreKeysSorted = nil;
	}
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
				return 3;
				break;
			case SECTION_COMPOSITION:
				return 2 + [self.oreKeysSorted count];
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
			return [LETableViewCellLabeledIconText getHeightForTableView:tableView];
			break;
		default:
			return 5.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Session *session = [Session sharedInstance];
	UITableViewCell *cell = nil;
    
	switch (indexPath.section) {
		case SECTION_BODY_OVERVIEW:
			switch (indexPath.row) {
				case BODY_OVERVIEW_ROW_NAME:
					; //DO NOT REMOVE
					LETableViewCellBody *bodyCell = [LETableViewCellBody getCellForTableView:tableView];
					bodyCell.planetImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"/assets/star_system/%@.png", session.body.imageName]];
					bodyCell.planetLabel.text = session.body.name;
					bodyCell.systemLabel.text = session.body.starName;
					bodyCell.orbitLabel.text = [NSString stringWithFormat:@"%@", session.body.orbit];
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
					renameBodyCell.textLabel.text = [NSString stringWithFormat:@"Rename %@", session.body.type];
					cell = renameBodyCell;
					break;
				case ACTION_ROW_ABANDON_BODY:
					; //DO NOT REMOVE
					LETableViewCellButton *abandonBodyCell = [LETableViewCellButton getCellForTableView:tableView];
					abandonBodyCell.textLabel.text = @"Abandon";
					cell = abandonBodyCell;
					break;
				default:
					break;
			}
			break;
		case SECTION_COMPOSITION:
			switch (indexPath.row) {
				case COMPOSITION_ROW_SIZE:
					; //DO NOT REMOVE
					LETableViewCellLabeledIconText *sizeCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
					sizeCell.label.text = @"Plots";
					sizeCell.icon.image = PLOTS_ICON;
					sizeCell.content.text = [NSString stringWithFormat:@"%@ (%@ used)", session.body.size, session.body.buildingCount];
					cell = sizeCell;
					break;
				case COMPOSITION_ROW_WATER:
					; //DO NOT REMOVE
					LETableViewCellLabeledIconText *waterCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
					waterCell.label.text = @"Water";
					waterCell.icon.image = WATER_ICON;
					waterCell.content.text = [NSString stringWithFormat:@"%@", session.body.planetWater];
					cell = waterCell;
					break;
				default:
					; //DO NOT REMOVE
					id oreTypeKey = [self.oreKeysSorted objectAtIndex:(indexPath.row-2)];
					id oreTypeValue = [self.watchedBody.ores objectForKey:oreTypeKey];
					LETableViewCellLabeledIconText *oreTypeCell = [LETableViewCellLabeledIconText getCellForTableView:tableView isSelectable:NO];
					oreTypeCell.label.text = [Util prettyCodeValue:[NSString stringWithFormat:@"%@", oreTypeKey]];
					oreTypeCell.icon.image = ORE_ICON;
					oreTypeCell.content.text = [NSString stringWithFormat:@"%@", oreTypeValue];
					cell = oreTypeCell;
					break;
			}
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
				ViewBodyMapControllerV2 *viewBodyMapController = [[ViewBodyMapControllerV2 alloc] init];
				[self.navigationController pushViewController:viewBodyMapController animated:YES];
				[viewBodyMapController release];
				break;
			case ACTION_ROW_RENAME_BODY:
				; //DO NOT REMOVE
				Session *session = [Session sharedInstance];
				RenameBodyController *renameBodyController = [RenameBodyController create];
				renameBodyController.body = session.body;
				[[self navigationController] pushViewController:renameBodyController animated:YES];
				break;
			case ACTION_ROW_ABANDON_BODY:
				; //DO NOT REMOVE
				UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you really wish to abandon this colony?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
				actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
				[actionSheet showFromTabBar:self.tabBarController.tabBar];
				[actionSheet release];
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
	self.pageSegmentedControl = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[self.reloadTimer invalidate];
	self.reloadTimer = nil;
	self.pageSegmentedControl = nil;
	self.bodyId = nil;
	self.watchedBody = nil;
	self.oreKeysSorted = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)clear {
	self.bodyId = nil;
	[self.tableView reloadData];
}


- (IBAction)logout {
	Session *session = [Session sharedInstance];
	[session logout];
}


#pragma mark -
#pragma mark PickColonyDelegate Methods

- (void)colonySelected:(NSString *)colonyId {
	self.bodyId = colonyId;
	[self loadBody];
	[self dismissModalViewControllerAnimated:YES];
	[self->pickColonyController release];
}


#pragma mark -
#pragma mark Private Methods
											  
- (void)loadBody {
	Session *session = [Session sharedInstance];
	[session loadBody:self.bodyId];
}


- (void)pickColony {
	Session *session = [Session	 sharedInstance];
	if ([session.empire.planets count] > 2) {
		self->pickColonyController = [[PickColonyController create] retain];
		self->pickColonyController.delegate = self;
		self->pickColonyController.colonies = session.empire.planets;
		[self presentModalViewController:self->pickColonyController animated:YES];
	} else {
		if ([[[session.empire.planets objectAtIndex:0] objectForKey:@"id"] isEqualToString:self.bodyId]) {
			self.bodyId = [[session.empire.planets objectAtIndex:1] objectForKey:@"id"];
		} else {
			self.bodyId = [[session.empire.planets objectAtIndex:0] objectForKey:@"id"];
		}
		[self loadBody];
	}
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[[[LEBodyAbandon alloc] initWithCallback:@selector(bodyAbandoned:) target:self forBody:self.bodyId] autorelease];
	}
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark -
#pragma mark Callback Methods

- (void)bodyAbandoned:(LEBodyAbandon *)request {
	if ([request wasError]) {
		//Rely on default error handling
	} else {
		Session *session = [Session sharedInstance];
		self.bodyId = session.empire.homePlanetId;
		[self loadBody];
	}
}


- (void)handleTimer:(NSTimer *)theTimer {
	if (theTimer == self.reloadTimer) {
		[self loadBody];
	}
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
		if (isNotNull(self.watchedBody)) {
			[self.watchedBody removeObserver:self forKeyPath:@"needsRefresh"];
		}
		
		Body *newBody = (Body *)[change objectForKey:NSKeyValueChangeNewKey];
		if (isNotNull(newBody)) {
			[newBody addObserver:self forKeyPath:@"needsRefresh" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
			self.watchedBody = newBody;
			self.oreKeysSorted = [[newBody.ores allKeys] sortedArrayUsingSelector:@selector(compare:)];
		} else {
			self.watchedBody = nil;
			self.oreKeysSorted = nil;
		}

		

		if (self.watchedBody) {
			self.navigationItem.title = self.watchedBody.name;
			self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:newBody.type],
										 [LEViewSectionTab tableView:self.tableView withText:@"Actions"],
										 [LEViewSectionTab tableView:self.tableView withText:@"Composition"]);
		} else {
			self.navigationItem.title = @"";
			self.sectionHeaders = nil;
		}

		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"needsRefresh"]) {
		self.navigationItem.title = self.watchedBody.name;
		[self.tableView reloadData];
	}
}


@end

