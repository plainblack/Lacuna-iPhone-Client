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
#import "LETableViewCellBody.h"
#import "LETableViewCellCurrentResources.h"
#import "ViewBodyMapController.h"
#import "RenameBodyController.h"
#import "LETableViewCellDictionary.h"
#import "PickColonyController.h"


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
	COMPOSITION_ROW_WATER,
	COMPOSITION_ROW_ORE
} COMPOSITION_ROW;

	
@interface ViewBodyController (PrivateMethods)

- (void)loadBody;
- (void)pickColony;

@end


@implementation ViewBodyController


@synthesize pageSegmentedControl;
@synthesize bodyId;
@synthesize watchedBody;


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
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)] autorelease];
	
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
	}

	if (![session.body.id isEqualToString:self.bodyId]) {
		self.navigationItem.title = @"Loading";
		[self loadBody];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.tableView reloadData];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


- (void)viewDidDisappear:(BOOL)animated {
	Session *session = [Session sharedInstance];
	if (self->watchingSession) {
		[session removeObserver:self forKeyPath:@"body"];
		[session removeObserver:self forKeyPath:@"lastTick"];
		self->watchingSession = NO;
	}
	if (isNotNull(self.watchedBody)) {
		[self.watchedBody removeObserver:self forKeyPath:@"needsRefresh"];
		self.watchedBody = nil;
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
				return 2;
				break;
			case SECTION_COMPOSITION:
				return 3;
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
			switch (indexPath.row) {
				case COMPOSITION_ROW_ORE:
					; //DON'T REMOVE
					Session *session = [Session sharedInstance];
					return [LETableViewCellDictionary getHeightForTableView:tableView numItems:[session.body.ores count]];
					break;
				default:
					return [LETableViewCellLabeledText getHeightForTableView:tableView];
					break;
			}
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
				default:
					break;
			}
			break;
		case SECTION_COMPOSITION:
			switch (indexPath.row) {
				case COMPOSITION_ROW_SIZE:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *sizeCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					sizeCell.label.text = @"Size";
					sizeCell.content.text = [NSString stringWithFormat:@"%@", session.body.size];
					cell = sizeCell;
					break;
				case COMPOSITION_ROW_ORE:
					; //DO NOT REMOVE
					LETableViewCellDictionary *oresCell = [LETableViewCellDictionary getCellForTableView:tableView];
					[oresCell setHeading:@"Ore" Data:session.body.ores];
					cell = oresCell;
					break;
				case COMPOSITION_ROW_WATER:
					; //DO NOT REMOVE
					LETableViewCellLabeledText *waterCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					waterCell.label.text = @"Water";
					waterCell.content.text = [NSString stringWithFormat:@"%@", session.body.planetWater];
					cell = waterCell;
					break;
				default:
					cell = nil;
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
				ViewBodyMapController *viewBodyMapController = [[ViewBodyMapController alloc] init];
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
	self.bodyId = nil;
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
	NSMutableArray *colonies = [NSMutableArray arrayWithCapacity:[session.empire.planets count]];
	[session.empire.planets enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		if (![session.body.id isEqualToString:key]) {
			[colonies addObject:_dict(key, @"id", obj, @"name")];
		}
	}];
	if ([colonies count] > 1) {
		self->pickColonyController = [[PickColonyController create] retain];
		self->pickColonyController.delegate = self;
		self->pickColonyController.colonies = colonies;
		[self presentModalViewController:self->pickColonyController animated:YES];
	} else {
		self.bodyId = [Util idFromDict:[colonies objectAtIndex:0] named:@"id"];
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
		} else {
			self.watchedBody = nil;
		}

		

		if (self.watchedBody) {
			self.navigationItem.title = self.watchedBody.name;
			self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView createWithText:newBody.type],
										 [LEViewSectionTab tableView:self.tableView createWithText:@"Actions"],
										 [LEViewSectionTab tableView:self.tableView createWithText:@"Composition"]);
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

