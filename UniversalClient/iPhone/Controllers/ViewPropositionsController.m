//
//  ViewPropositionsController.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/21/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ViewPropositionsController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Parliament.h"
#import "Proposition.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellParagraph.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellVotes.h"
#import "LEBuildingCastVote.h"
#import "ViewPublicEmpireProfileController.h"


@implementation ViewPropositionsController


@synthesize parliament;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Propositions";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.sectionHeaders = [NSArray array];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.parliament addObserver:self forKeyPath:@"propositions" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    [self.parliament loadPropositions];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.parliament removeObserver:self forKeyPath:@"propositions"];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return MAX(1, [self.parliament.propositions count]);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.parliament.propositions && [self.parliament.propositions count] > 0) {
        Proposition *proposition = [self.parliament.propositions objectAtIndex:section];
        return [proposition numPropositionRowTypes];
    } else {
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.parliament.propositions && [self.parliament.propositions count] > 0) {
        Proposition *proposition = [self.parliament.propositions objectAtIndex:indexPath.section];
        switch ([proposition propositionRowType:indexPath.row]) {
            case PROPOSITION_ROW_DESCRIPTION:
                return [LETableViewCellParagraph getHeightForTableView:tableView text:proposition.descriptionText];
                break;
            case PROPOSITION_ROW_STATUS:
            case PROPOSITION_ROW_END_DATE:
            case PROPOSITION_ROW_MY_VOTE:
                return [LETableViewCellLabeledText getHeightForTableView:tableView];
                break;
            case PROPOSITION_ROW_PROPOSED_BY:
            case PROPOSITION_ROW_VOTE_YES:
            case PROPOSITION_ROW_VOTE_NO:
                return [LETableViewCellButton getHeightForTableView:tableView];
            case PROPOSITION_ROW_VOTES:
                return [LETableViewCellVotes getHeightForTableView:tableView];
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
    
    if (self.parliament.propositions) {
        if ([self.parliament.propositions count] > 0) {
            Proposition *proposition = [self.parliament.propositions objectAtIndex:indexPath.section];
            switch ([proposition propositionRowType:indexPath.row]) {
                case PROPOSITION_ROW_DESCRIPTION:
                    ; //DO NOT REMOVE
                    LETableViewCellParagraph *descriptionCell = [LETableViewCellParagraph getCellForTableView:tableView];
                    descriptionCell.content.text = proposition.descriptionText;
                    cell = descriptionCell;
                    break;
                case PROPOSITION_ROW_STATUS:
                    ; //DO NOT REMOVE
                    LETableViewCellLabeledText *statusCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                    statusCell.label.text = @"Status";
                    statusCell.content.text = proposition.status;
                    cell = statusCell;
                    break;
                case PROPOSITION_ROW_PROPOSED_BY:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *proposedByCell = [LETableViewCellButton getCellForTableView:tableView];
                    proposedByCell.textLabel.text = [NSString stringWithFormat: @"Proposed By: %@", proposition.proposedByName];
                    cell = proposedByCell;
                    break;
                case PROPOSITION_ROW_END_DATE:
                    ; //DO NOT REMOVE
                    LETableViewCellLabeledText *endDateCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                    endDateCell.label.text = @"Voting Ends";
                    endDateCell.content.text = [Util formatDate:proposition.dateEnds];
                    cell = endDateCell;
                    break;
                case PROPOSITION_ROW_VOTES:
                    ; //DO NOT REMOVE
                    LETableViewCellVotes *votesCell = [LETableViewCellVotes getCellForTableView:tableView];
                    [votesCell setVotesNeeded:proposition.votesNeeded votesFor:proposition.votesYes votesAgainst:proposition.votesNo];
                    cell = votesCell;
                    break;
                case PROPOSITION_ROW_MY_VOTE:
                    ; //DO NOT REMOVE
                    LETableViewCellLabeledText *myVotesCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                    myVotesCell.label.text = @"My Vote";
                    if ([proposition.myVote boolValue]) {
                        myVotesCell.content.text = @"FOR";
                    } else {
                        myVotesCell.content.text = @"AGAINST";
                    }
                    cell = myVotesCell;
                    break;
                case PROPOSITION_ROW_VOTE_YES:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *voteYesCell = [LETableViewCellButton getCellForTableView:tableView];
                    voteYesCell.textLabel.text = @"Vote For";
                    cell = voteYesCell;
                    break;
                case PROPOSITION_ROW_VOTE_NO:
                    ; //DO NOT REMOVE
                    LETableViewCellButton *voteNoCell = [LETableViewCellButton getCellForTableView:tableView];
                    voteNoCell.textLabel.text = @"Vote Against";
                    cell = voteNoCell;
                    break;
                default:
                    break;
            }
        } else {
            LETableViewCellLabeledText *noneCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
            noneCell.label.text = @"Propositions";
            noneCell.content.text = @"None";
            cell = noneCell;
        }
    } else {
        LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
        loadingCell.label.text = @"Propositions";
        loadingCell.content.text = @"Loading";
        cell = loadingCell;
    }

    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.parliament.propositions) {
        if ([self.parliament.propositions count] > 0) {
            Proposition *proposition = [self.parliament.propositions objectAtIndex:indexPath.section];
            switch ([proposition propositionRowType:indexPath.row]) {
                case PROPOSITION_ROW_PROPOSED_BY:
                    ; //DO NOT REMOVE
                    ViewPublicEmpireProfileController *viewPublicEmpireProfileController = [ViewPublicEmpireProfileController create];
                    viewPublicEmpireProfileController.empireId = proposition.proposedById;
                    [self.navigationController pushViewController:viewPublicEmpireProfileController animated:YES];
                    break;
                case PROPOSITION_ROW_VOTE_YES:
                    [self.parliament castVote:YES propositionId:proposition.id target:self callback:@selector(voteCast:)];
                    break;
                case PROPOSITION_ROW_VOTE_NO:
                    [self.parliament castVote:NO propositionId:proposition.id target:self callback:@selector(voteCast:)];
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
    [super viewDidUnload];
}


- (void)dealloc {
	self.parliament = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Callback Methods

- (void)voteCast:(LEBuildingCastVote *)request {
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"propositions"]) {
        NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[self.parliament.propositions count]];
        [self.parliament.propositions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            Proposition *proposition = obj;
            [tmp addObject:[LEViewSectionTab tableView:self.tableView withText:proposition.name]];
        }];
        self.sectionHeaders = tmp;
		[self.tableView reloadData];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (ViewPropositionsController *)create {
	ViewPropositionsController *viewPropositionsController = [[[ViewPropositionsController alloc] init] autorelease];
	return viewPropositionsController;
}


@end
