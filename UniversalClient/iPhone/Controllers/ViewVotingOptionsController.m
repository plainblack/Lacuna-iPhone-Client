//
//  ViewVotingOptionsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 10/13/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewVotingOptionsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Entertainment.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellParagraph.h"
#import "LETableViewCellButton.h"
#import "WebPageController.h"

#define VOTING_INSTRUCTIONS @"To help promote Lacuna Expanse you can vote on a site once and only once per day and each vote enters you into the daily lottery. At the end of the day a lottery ticket will be drawn, and a winner will be chosen to receive 10 essentia. Every vote is equal, but the more votes you have the greater your odds of winning."


typedef enum {
	SECTION_DESCRIPTION,
	SECTION_VOTING_OPTIONS,
} SECTION;


@implementation ViewVotingOptionsController


@synthesize entertainment;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Lottery Voting Options";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Instructions"], [LEViewSectionTab tableView:self.tableView withText:@"Sites"]);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.entertainment addObserver:self forKeyPath:@"needsRefresh" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	if (!self.entertainment.votingOptions) {
		[self.entertainment loadVotingOptions];
	} else {
		[self.tableView reloadData];
	}

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.entertainment removeObserver:self forKeyPath:@"needsRefresh"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_DESCRIPTION:
			return 1;
			break;
		case SECTION_VOTING_OPTIONS:
			if (self.entertainment && self.entertainment.votingOptions) {
				if ([self.entertainment.votingOptions count] > 0) {
					return [self.entertainment.votingOptions count];
				} else {
					return 1;
				}
			} else {
				return 1;
			}
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_DESCRIPTION:
			return [LETableViewCellParagraph getHeightForTableView:tableView text:VOTING_INSTRUCTIONS];
			break;
		case SECTION_VOTING_OPTIONS:
			if (self.entertainment && self.entertainment.votingOptions) {
				if ([self.entertainment.votingOptions count] > 0) {
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
    UITableViewCell *cell = nil;

	switch (indexPath.section) {
		case SECTION_DESCRIPTION:
			; //DO NOT REMOVE
			LETableViewCellParagraph *instructionsCell = [LETableViewCellParagraph getCellForTableView:tableView];
			instructionsCell.content.text = VOTING_INSTRUCTIONS;
			cell = instructionsCell;
			break;
		case SECTION_VOTING_OPTIONS:
			if (self.entertainment && self.entertainment.votingOptions) {
				if ([self.entertainment.votingOptions count] > 0) {
					NSMutableDictionary *votingOption = [self.entertainment.votingOptions objectAtIndex:indexPath.row];
					LETableViewCellButton *emptyCell = [LETableViewCellButton getCellForTableView:tableView];
					emptyCell.textLabel.text = [votingOption objectForKey:@"name"];
					cell = emptyCell;
				} else {
					LETableViewCellLabeledText *emptyCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
					emptyCell.label.text = @"Sites";
					emptyCell.content.text = @"None Available Now";
					cell = emptyCell;
				}
			} else {
				LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingCell.label.text = @"Sites";
				loadingCell.content.text = @"Loading";
				cell = loadingCell;
			}
			break;
		default:
			cell = nil;
			break;
	}
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_VOTING_OPTIONS:
			if (self.entertainment && self.entertainment.votingOptions && [self.entertainment.votingOptions count] > 0) {
				NSMutableDictionary *votingOption = [self.entertainment.votingOptions objectAtIndex:indexPath.row];
				[votingOption retain];
				NSString *url = [votingOption objectForKey:@"url"];
				[self.entertainment removeVotingOptionNamed:[votingOption objectForKey:@"name"]];
				WebPageController *webPageController = [WebPageController create];
				[webPageController goToUrl:url];
				[self presentViewController:webPageController animated:YES completion:nil];
				[votingOption release];
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
	self.entertainment = nil;
    [super dealloc];
}



#pragma mark -
#pragma mark Class Methods

+ (ViewVotingOptionsController *)create {
	return [[[ViewVotingOptionsController alloc] init] autorelease];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"needsRefresh"]) {
		[self.tableView reloadData];
	}
}


@end

