//
//  ChooseWritTemplateViewController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/9/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ChooseWritTemplateViewController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Parliament.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellWebView.h"
#import "LETableViewCellButton.h"
#import "WebPageController.h"
#import "ViewAllianceProfileController.h"
#import "ViewPublicEmpireProfileController.h"
#import "LEBuildingCastVote.h"
#import "AppDelegate_Phone.h"
#import "NewWritViewController.h"


typedef enum {
    ROW_NAME,
    ROW_DESCRIPTION,
    ROW_CHOOSE,
} ROWS;


@implementation ChooseWritTemplateViewController


@synthesize writTemplates;
@synthesize parliament;
@synthesize webViewCells;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Writ Templates";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];

    if (!self.writTemplates) {
        Session *session = [Session sharedInstance];
        self.writTemplates = [session.itemDescriptions objectForKey:@"writ_templates"];
        [self.writTemplates addObject:_dict(@"Blank",@"title",@"",@"description")];
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.writTemplates count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case ROW_DESCRIPTION:
            return [self getCellForIndexPath:indexPath].height;
            break;
        case ROW_NAME:
            return [LETableViewCellLabeledText getHeightForTableView:tableView];
            break;
        case ROW_CHOOSE:
            return [LETableViewCellButton getHeightForTableView:tableView];
        default:
            return 0;
            break;
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
    
    NSMutableDictionary *writTemplate = [self.writTemplates objectAtIndex:indexPath.section];
    switch (indexPath.row) {
        case ROW_DESCRIPTION:
            ; //DO NOT REMOVE
            LETableViewCellWebView *descriptionCell = [self getCellForIndexPath:indexPath];
            [descriptionCell setContent:[writTemplate objectForKey:@"description"]];
            cell = descriptionCell;
            break;
        case ROW_NAME:
            ; //DO NOT REMOVE
            LETableViewCellLabeledText *nameCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
            nameCell.label.text = @"Title";
            nameCell.content.text = [writTemplate objectForKey:@"title"];
            cell = nameCell;
            break;
        case ROW_CHOOSE:
            ; //DO NOT REMOVE
            LETableViewCellButton *chooseCell = [LETableViewCellButton getCellForTableView:tableView];
            chooseCell.textLabel.text = @"Choose";
            cell = chooseCell;
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *writTemplate = [self.writTemplates objectAtIndex:indexPath.section];
    switch (indexPath.row) {
        case ROW_CHOOSE:
            ; //DO NOT REMOVE
            NewWritViewController *newWritViewController = [NewWritViewController create];
            newWritViewController.parliament = self.parliament;
            newWritViewController.writTemplate = writTemplate;
            [self.navigationController pushViewController:newWritViewController animated:YES];
            break;
        default:
            //Does nothing but removes compiler warning
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
    [self.webViewCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [obj removeObserver:self forKeyPath:@"height"];
    }];
    [self.webViewCells removeAllObjects];
    self.writTemplates = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.parliament = nil;
    [self.webViewCells enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [obj removeObserver:self forKeyPath:@"height"];
    }];
    [self.webViewCells removeAllObjects];
    self.webViewCells = nil;
    self.writTemplates = nil;
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


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( [keyPath isEqualToString:@"height"]) {
        if (!self.tableView.dragging) {
            [self.tableView reloadData];
        }
	}
}


#pragma mark -
#pragma mark Class Methods

+ (ChooseWritTemplateViewController *)create {
	ChooseWritTemplateViewController *chooseWritTemplateViewController = [[[ChooseWritTemplateViewController alloc] init] autorelease];
	return chooseWritTemplateViewController;
}


@end
