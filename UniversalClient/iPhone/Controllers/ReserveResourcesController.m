//
//  StoreResourcesController.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/15/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ReserveResourcesController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "DistributionCenter.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellParagraph.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellButton.h"
#import "LEBuildingReserve.h"
#import "SelectResourceTypeFromListController.h"
#import "LEBuildingGetTradeableStoredResources.h"


#define NOTHING_SELECTED_MESSAGE @"Select something below"


typedef enum {
    SECTION_RESERVE,
    SECTION_DETAILS
} SECTION;


typedef enum {
    DETAIL_ROW_SPACE_LEFT,
    DETAIL_ROW_RESERVE_BUTTON,
} DETAIL_ROW;


@implementation ReserveResourcesController


@synthesize distributionCenter;
@synthesize reserveRequest;
@synthesize storedResources;
@synthesize cargoSpaceUsedPer;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Reserve" style:UIBarButtonItemStyleDone target:self action:@selector(reserve)] autorelease];
    
    self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"What To Reserve"], [LEViewSectionTab tableView:self.tableView withText:@"Details"]);
    
    if (!self.storedResources) {
        [self.distributionCenter getStoredResourcesTarget:self callback:@selector(gotStoredResources:)];
    }

    if (!self.reserveRequest) {
        self.reserveRequest = [NSMutableArray arrayWithCapacity:5];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.storedResources) {
        return 2;
    } else {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.storedResources) {
        switch (section) {
            case SECTION_RESERVE:
                return [self.reserveRequest count] + 1;
                break;
            case SECTION_DETAILS:
                return 2;
                break;
            default:
                return 0;
        }
    } else {
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.storedResources) {
        switch (indexPath.section) {
            case SECTION_RESERVE:
                if (indexPath.row < [self.reserveRequest count]) {
                    return [LETableViewCellLabeledText getHeightForTableView:tableView];
                } else  {
                    return [LETableViewCellButton getHeightForTableView:tableView];
                }
                break;
            case SECTION_DETAILS:
                switch (indexPath.row) {
                    case DETAIL_ROW_SPACE_LEFT:
                        return [LETableViewCellLabeledText getHeightForTableView:tableView];
                        break;
                    case DETAIL_ROW_RESERVE_BUTTON:
                        return [LETableViewCellButton getHeightForTableView:tableView];
                        break;
                    default:
                        return 0;
                        break;
                }
                return [LETableViewCellButton getHeightForTableView:tableView];
                break;
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
	
    if (self.storedResources) {
        switch (indexPath.section) {
            case SECTION_RESERVE:
                if (indexPath.row < [self.reserveRequest count]) {
                    NSMutableDictionary *tmp = [self.reserveRequest objectAtIndex:indexPath.row];
                    LETableViewCellLabeledText *resourceCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                    resourceCell.label.text = [Util prettyCodeValue:[tmp objectForKey:@"type"]];
                    resourceCell.content.text = [Util prettyNSDecimalNumber:[tmp objectForKey:@"quanity"]]; //KEVIN SHOULD THIS BE quantity?
                    cell = resourceCell;
                } else {
                    LETableViewCellButton *addResourceCell = [LETableViewCellButton getCellForTableView:tableView];
                    addResourceCell.textLabel.text = @"Add Resource";
                    cell = addResourceCell;
                }
                break;
            case SECTION_DETAILS:
                switch (indexPath.row) {
                    case DETAIL_ROW_SPACE_LEFT:
                        ; //DO NOT REMOVE
                        LETableViewCellLabeledText *spaceLeftCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
                        spaceLeftCell.label.text = @"Space Left";
                        NSDecimalNumber *spaceUsed = [NSDecimalNumber zero];
                        for (int i=0; i < [self.reserveRequest count]; i++) {
                            NSDecimalNumber *amount = [[self.reserveRequest objectAtIndex:i] objectForKey:@"quanity"];
                            spaceUsed = [spaceUsed decimalNumberByAdding:amount];
                        }
                        spaceUsed = [spaceUsed decimalNumberByMultiplyingBy:self.cargoSpaceUsedPer];
                        NSDecimalNumber *spaceLeft = [self.distributionCenter.maxReserverSize decimalNumberBySubtracting:spaceUsed];
                        spaceLeftCell.content.text = [Util prettyNSDecimalNumber:spaceLeft];
                        cell = spaceLeftCell;
                        break;
                    case DETAIL_ROW_RESERVE_BUTTON:
                        ; //DO NOT REMOVE
                        LETableViewCellButton *reserveResourcesCell = [LETableViewCellButton getCellForTableView:tableView];
                        reserveResourcesCell.textLabel.text = @"Reserve";
                        cell = reserveResourcesCell;
                        break;
                    default:
                        return 0;
                        break;
                }
                break;
        }
    } else {
        LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
        loadingCell.label.text = @"Resources";
        loadingCell.content.text = @"Loading";
        cell = loadingCell;
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.storedResources) {
        switch (indexPath.section) {
            case SECTION_RESERVE:
                if (indexPath.row >= [self.reserveRequest count]) {
                    self->selectResourceTypeFromListController = [[SelectResourceTypeFromListController create] retain];
                    self->selectResourceTypeFromListController.delegate = self;
                    self->selectResourceTypeFromListController.storedResourceTypes = self.storedResources;
                    [self.navigationController pushViewController:self->selectResourceTypeFromListController animated:YES];
                }
                break;
            case SECTION_DETAILS:
                switch (indexPath.row) {
                    case DETAIL_ROW_RESERVE_BUTTON:
                        [self reserve];
                        break;
                }
                break;
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.storedResources) {
        switch (indexPath.section) {
            case SECTION_RESERVE:
                return indexPath.row < [self.reserveRequest count];
                break;
            default:
                return NO;
        }
    } else {
        return NO;
    }
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.storedResources) {
        switch (indexPath.section) {
            case SECTION_RESERVE:
                if (indexPath.row < [self.reserveRequest count]) {
                    NSMutableDictionary *tmp = [self.reserveRequest objectAtIndex:indexPath.row];
                    NSString *type = [tmp objectForKey:@"type"];
                    NSDecimalNumber *amount = [tmp objectForKey:@"quanity"]; //KEVIN Should this be quantity?
                    NSDecimalNumber *oldAmount = [self.storedResources objectForKey:type];
                    NSDecimalNumber *newAmount = [oldAmount decimalNumberByAdding:amount];
                    [self.storedResources setObject:newAmount forKey:type];
                    [self.reserveRequest removeObject:tmp];
                    [tableView deleteRowsAtIndexPaths:_array(indexPath) withRowAnimation:UITableViewRowAnimationFade];
                    [tableView reloadRowsAtIndexPaths:_array([NSIndexPath indexPathForRow:DETAIL_ROW_SPACE_LEFT inSection:SECTION_DETAILS]) withRowAnimation:UITableViewRowAnimationMiddle];
                }
                break;
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
	self.distributionCenter = nil;
	self.reserveRequest = nil;
    self.storedResources = nil;
	[self->selectResourceTypeFromListController release];
    self->selectResourceTypeFromListController = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (IBAction)reserve {
	if ([self.reserveRequest count] > 0) {
        [self.distributionCenter reserve:self.reserveRequest target:self callback:@selector(resourcesReserved:)];
	} else {
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Incomplete" message: @"You must have something added to reserve." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
	}
}


#pragma mark -
#pragma mark SelectResourceTypeFromListControllerDelegate Methods

- (void)selectedStoredResourceType:(NSString *)type amount:(NSDecimalNumber *)amount {
    NSDecimalNumber *originalAmount = [self.storedResources objectForKey:type];
    if ([originalAmount compare:amount] == NSOrderedAscending) {
        amount = originalAmount;
    }
    NSDecimalNumber *newAmount = [originalAmount decimalNumberBySubtracting:amount];
    [self.storedResources setObject:newAmount forKey:type];
    
    __block NSMutableDictionary *foundDict = nil;
    [self.reserveRequest enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSString *tmpType = [obj objectForKey:@"type"];
        if ([tmpType isEqualToString:type]) {
            foundDict = obj;
            NSDecimalNumber *tmpAmount = [foundDict objectForKey:@"quanity"]; //Should this be quantity?
            [foundDict setObject:[tmpAmount decimalNumberByAdding:amount] forKey:@"quanity"]; //Should this be quantity?
            *stop = YES;
        }
    }];
    if (!foundDict) {
        [self.reserveRequest addObject:_dict(type, @"type", amount, @"quanity")]; //Should this be quantity?
    }
	[self.navigationController popViewControllerAnimated:YES];
	[self->selectResourceTypeFromListController release];
	self->selectResourceTypeFromListController = nil;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Callbacks

- (void) gotStoredResources:(LEBuildingGetTradeableStoredResources *)request {
    self.cargoSpaceUsedPer = request.cargoSpaceUsedPer;
	self.storedResources = request.storedResources;
    
    self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"What To Reserve"], [LEViewSectionTab tableView:self.tableView withText:@"Details"]);
    [self.tableView reloadData];
}


- (void)resourcesReserved:(LEBuildingReserve *)request {
	if ([request wasError]) {
		NSString *errorText = [request errorMessage];
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Error" message:errorText preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
		[request markErrorHandled];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark Class Methods

+ (ReserveResourcesController *)create {
	return [[[ReserveResourcesController alloc] init] autorelease];
}


@end
