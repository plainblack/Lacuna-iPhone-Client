//
//  ViewLawController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/8/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ViewLawsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Parliament.h"
#import "Law.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellWebView.h"
#import "LETableViewCellButton.h"
#import "LEBuildingProposeRepealLaw.h"
#import "WebPageController.h"
#import "ViewAllianceProfileController.h"
#import "ViewPublicEmpireProfileController.h"
#import "AppDelegate_Phone.h"
#import "LEBuildingCastVote.h"


typedef enum {
    ROW_NAME,
    ROW_DESCRIPTION,
    ROW_DATE_ENACTED,
    ROW_REPEAL,
} ROWS;


@implementation ViewLawsController


@synthesize parliament;
@synthesize webViewCells;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Laws";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
    
    self->watchingLaws = NO;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self->watchingLaws = YES;
    [self.parliament addObserver:self forKeyPath:@"laws" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    Session *session = [Session sharedInstance];
    [self.parliament loadLawsForStationId:session.body.id];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self->watchingLaws) {
        [self.parliament removeObserver:self forKeyPath:@"laws"];
        self->watchingLaws = NO;
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(1, [self.parliament.laws count]);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.parliament.laws && [self.parliament.laws count] > 0) {
        return 4;
    } else {
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.parliament.laws && [self.parliament.laws count] > 0) {
        switch (indexPath.row) {
            case ROW_DESCRIPTION:
                return [self getCellForIndexPath:indexPath].height;
                break;
            case ROW_NAME:
            case ROW_DATE_ENACTED:
                return [LETableViewCellLabeledText getHeightForTableView:tableView];
                break;
            case ROW_REPEAL:
                return [LETableViewCellButton getHeightForTableView:tableView];
            default:
                return 0;
                break;
        }
    } else {
        return [LETableViewCellLabeledText getHeightForTableView:tableView];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
    
    if (self.parliament.laws) {
        if ([self.parliament.laws count] > 0) {
            Law *law = [self.parliament.laws objectAtIndex:indexPath.section];
            switch (indexPath.row) {
                case ROW_DESCRIPTION:
                    ; //DO NOT REMOVE
                    LETableViewCellWebView *descriptionCell = [self getCellForIndexPath:indexPath];
                    [descriptionCell setContent:law.descriptionText];
                    cell = descriptionCell;
                    break;
                case ROW_NAME:
                    ; //DO NOT REMOVE
                    LETableViewCellLabeledText *nameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                    nameCell.label.text = @"Name";
                    nameCell.content.text = law.name;
                    cell = nameCell;
                    break;
                case ROW_DATE_ENACTED:
                    ; //DO NOT REMOVE
                    LETableViewCellLabeledText *enactedDateCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                    enactedDateCell.label.text = @"Enacted Date";
                    enactedDateCell.content.text = [Util formatDate:law.dateEnacted];
                    cell = enactedDateCell;
                    break;
                case ROW_REPEAL:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *repealCell = [LETableViewCellButton getCellForTableView:tableView];
                    repealCell.textLabel.text = @"Repeal This Law";
                    cell = repealCell;
                    break;
                default:
                    break;
            }
        } else {
            LETableViewCellLabeledText *noneCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
            noneCell.label.text = @"Laws";
            noneCell.content.text = @"None";
            cell = noneCell;
        }
    } else {
        LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
        loadingCell.label.text = @"Laws";
        loadingCell.content.text = @"Loading";
        cell = loadingCell;
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.parliament.laws) {
        if ([self.parliament.laws count] > 0) {
            Law *law = [self.parliament.laws objectAtIndex:indexPath.section];
            switch (indexPath.row) {
                case ROW_REPEAL:
                    [self.parliament repealLaw:law target:self callback:@selector(proposedRepealLaw:)];
                    break;
                default:
                    //Does nothing but removes compiler warning
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
    [self.webViewCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [obj removeObserver:self forKeyPath:@"height"];
    }];
    [self.webViewCells removeAllObjects];
    [super viewDidUnload];
}


- (void)dealloc {
	self.parliament = nil;
    [self.webViewCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [obj removeObserver:self forKeyPath:@"height"];
    }];
    [self.webViewCells removeAllObjects];
    self.webViewCells = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (LETableViewCellWebView *)getCellForIndexPath:(NSIndexPath *)indexPath {
    if (!self.webViewCells) {
        self.webViewCells = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    NSString *key = [NSString stringWithFormat:@"%i-%i", indexPath.section, indexPath.row];
    LETableViewCellWebView *cell = nil;
    
    cell = [self.webViewCells objectForKey:key];
    
    if (isNull(cell)) {
        cell = [LETableViewCellWebView getCellForTableView:self.tableView dequeueable:NO];
        cell.delegate = self;
        [cell addObserver:self forKeyPath:@"height" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
        [self.webViewCells setObject:cell forKey:key];
    }
    
    return cell;
}


#pragma mark -
#pragma mark LETableViewCellWebViewDelegate Methods

- (void)showWebPage:(NSString*)url {
	WebPageController *webPageController = [WebPageController create];
	[webPageController goToUrl:url];
	[self presentViewController:webPageController animated:YES completion:nil];
}


- (void)showEmpireProfile:(NSString *)inEmpireId {
	ViewPublicEmpireProfileController *viewPublicEmpireProfileController = [ViewPublicEmpireProfileController create];
	viewPublicEmpireProfileController.empireId = inEmpireId;
	[self.navigationController pushViewController:viewPublicEmpireProfileController animated:YES];
}


- (void)showAllianceProfile:(NSString *)allianceId {
	ViewAllianceProfileController *viewAllianceProfileController = [ViewAllianceProfileController create];
	viewAllianceProfileController.allianceId = allianceId;
	[self.navigationController pushViewController:viewAllianceProfileController animated:YES];
}


- (void)showMyPlanet:(NSString *)myPlanetId {
	AppDelegate_Phone *delgate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
	[delgate showMyWorld:myPlanetId];
}


- (void)showStarmap:(NSString *)starmapLoc {
	NSArray *parts = [starmapLoc componentsSeparatedByString:@"."];
	NSDecimalNumber *gridX = [Util asNumber:[parts objectAtIndex:0]];
	NSDecimalNumber *gridY = [Util asNumber:[parts objectAtIndex:1]];
	AppDelegate_Phone *delgate = (AppDelegate_Phone *)[UIApplication sharedApplication].delegate;
	[delgate showStarMapGridX:gridX gridY:gridY];
	[self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)voteYesForBody:(NSString *)bodyId building:(NSString *)buildingId proposition:(NSString *)propositionId {
    [[[LEBuildingCastVote alloc] initWithCallback:@selector(voteCast:) target:self buildingId:buildingId buildingUrl:PARLIAMENT_URL propositionId:propositionId vote:YES] autorelease];
}


- (void)voteNoForBody:(NSString *)bodyId building:(NSString *)buildingId proposition:(NSString *)propositionId {
    [[[LEBuildingCastVote alloc] initWithCallback:@selector(voteCast:) target:self buildingId:buildingId buildingUrl:PARLIAMENT_URL propositionId:propositionId vote:NO] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (void)voteCast:(LEBuildingCastVote *)request {
    [self.tableView reloadData];
}


- (void)proposedRepealLaw:(LEBuildingProposeRepealLaw *)request {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"laws"]) {
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[self.parliament.laws count]];
        [self.parliament.laws enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            Law *law = obj;
            [tmp addObject:[LEViewSectionTab tableView:self.tableView withText:law.name]];
        }];
        self.sectionHeaders = tmp;
		[self.tableView reloadData];
	} else if ( [keyPath isEqualToString:@"height"]) {
        if (!self.tableView.dragging) {
            [self.tableView reloadData];
        }
	}
}


#pragma mark -
#pragma mark Class Methods

+ (ViewLawsController *)create {
	ViewLawsController *viewLawsController = [[[ViewLawsController alloc] init] autorelease];
	return viewLawsController;
}


@end
