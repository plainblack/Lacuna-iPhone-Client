//
//  ViewMailMessageWebController.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/14/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMailMessageWebController.h"
#import "LEMacros.h"
#import "Util.h"
#import "BuildingUtil.h"
#import "Mailbox.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellMailHeaders.h"
#import "LETableViewCellWebView.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellAttachedImage.h"
#import "LETableViewCellAttachedLink.h"
#import "ViewAttachedTableController.h"
#import "ViewAttachedMapController.h"
#import "NewMailMessageController.h"
#import "WebPageController.h"
#import "ViewPublicEmpireProfileController.h"
#import "ViewAllianceProfileController.h"
#import "AppDelegate_Phone.h"
#import "LEBuildingCastVote.h"


typedef enum {
	REPLY_TO_BUTTON_INDEX,
	FORWARD_BUTTON_INDEX
} RESEND_BUTTON_INDEXES;


@implementation ViewMailMessageWebController


@synthesize messageSegmentedControl;
@synthesize mailbox;
@synthesize messageIndex;
@synthesize messageId;
@synthesize bodyCell;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Loading";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.messageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.messageSegmentedControl addTarget:self action:@selector(switchMessage) forControlEvents:UIControlEventValueChanged]; 
	self.messageSegmentedControl.momentary = YES;
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.messageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	UIBarButtonItem *fixed = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
	fixed.width = 20;
	
	self.toolbarItems = [NSArray arrayWithObjects:
						 fixed,
						 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(archiveMessage)] autorelease],
						 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
						 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(resendMessage)] autorelease],
						 fixed,
						 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessage)] autorelease],
						 fixed,
						 nil];
	
	self.sectionHeaders = [NSMutableArray array];
	
	self.bodyCell = [LETableViewCellWebView getCellForTableView:self.tableView dequeueable:YES];
	self.bodyCell.delegate = self;
	[self.bodyCell addObserver:self forKeyPath:@"height" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[self.navigationController setToolbarHidden:NO animated:NO];
	
	[self.mailbox addObserver:self forKeyPath:@"messageDetails" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[self.mailbox addObserver:self forKeyPath:@"messageHeaders" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	isObserving = YES;
	if (self.messageId) {
		[self.mailbox loadMessageById:self.messageId];
		self.messageSegmentedControl.hidden = YES;
	} else {
		[self.mailbox loadMessage:self.messageIndex];
		self.messageSegmentedControl.hidden = NO;
	}

}


- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	if (self.mailbox && isObserving) {
		[self.mailbox removeObserver:self forKeyPath:@"messageDetails"];
		[self.mailbox removeObserver:self forKeyPath:@"messageHeaders"];
		isObserving = NO;
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.mailbox.messageDetails) {
		if (self->hasAttachements) {
			return 3;
		} else {
			return 2;
		}
	} else {
		return 1;
	}
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
			break;
		case 1:
			if (self.mailbox.messageDetails && self->hasAttachements) {
				return [self->attachements count];
			} else {
				return 1;
			}
			break;
		case 2:
			if (self.mailbox.messageDetails && self->hasAttachements) {
				return 1;
			} else {
				return 0;
			}
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			if (self.mailbox.messageDetails) {
				return [LETableViewCellMailHeaders getHeightForTableView:tableView];
			} else {
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}
			break;
		case 1:
			if (self.mailbox.messageDetails) {
				if (self->hasAttachements) {
					NSInteger attachmentIndex = indexPath.row;
					NSString *key = [[attachements allKeys] objectAtIndex:attachmentIndex];
					
					if ([key isEqualToString:@"image"]) {
						return [LETableViewCellAttachedImage getHeightForTableView:tableView];
					} else if ([key isEqualToString:@"link"]) {
						return [LETableViewCellAttachedLink getHeightForTableView:tableView];
					} else if ([key isEqualToString:@"table"]) {
						return [LETableViewCellButton getHeightForTableView:tableView];
					} else if ([key isEqualToString:@"map"]) {
						return [LETableViewCellButton getHeightForTableView:tableView];
					} else {
						return 0.0;
					}
				} else {
					; //DO NOT REMOVE
					return self.bodyCell.height;
				}
			} else {
				return 0.0;
			}
			break;
		case 2:
			if (self.mailbox.messageDetails && self->hasAttachements) {
				; //DO NOT REMOVE
				return self.bodyCell.height;
			} else {
				return 0.0;
			}
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case 0:
			if (self.mailbox.messageDetails) {
				LETableViewCellMailHeaders *headersCell = [LETableViewCellMailHeaders getCellForTableView:tableView];
				[headersCell setMessage:self.mailbox.messageDetails];
				cell = headersCell;
			} else {
				LETableViewCellLabeledText *loadingCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				loadingCell.label.text = @"Message";
				loadingCell.content.text = @"Loading";
				cell = loadingCell;
			}
			break;
		case 1:
			if (self.mailbox.messageDetails) {
				if (self->hasAttachements) {
					NSInteger attachmentIndex = indexPath.row;
					NSString *key = [[self->attachements allKeys] objectAtIndex:attachmentIndex];
					
					if ([key isEqualToString:@"image"]) {
						LETableViewCellAttachedImage *imageCell = [LETableViewCellAttachedImage getCellForTableView:tableView];
						[imageCell setData:[attachements objectForKey:key]];
						cell = imageCell;
					} else if ([key isEqualToString:@"link"]) {
						LETableViewCellAttachedLink *linkCell = [LETableViewCellAttachedLink getCellForTableView:tableView];
						[linkCell setData:[attachements objectForKey:key]];
						cell = linkCell;
					} else if ([key isEqualToString:@"table"]) {
						LETableViewCellButton *tableCell = [LETableViewCellButton getCellForTableView:tableView];
						tableCell.textLabel.text = @"Attached Table";
						cell = tableCell;
					} else if ([key isEqualToString:@"map"]) {
						LETableViewCellButton *mapCell = [LETableViewCellButton getCellForTableView:tableView];
						mapCell.textLabel.text = @"Attached Map";
						cell = mapCell;
					} else {
						cell = nil;
					}
				} else {
					cell = self.bodyCell;
				}
			} else {
				cell = nil;
			}
			break;
		case 2:
			if (self.mailbox.messageDetails && self->hasAttachements) {
				cell = self.bodyCell;
			} else {
				cell = nil;
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
	if (self->hasAttachements && indexPath.section == 1) {
		if (self->hasAttachements) {
			NSInteger attachmentIndex = indexPath.row;
			NSString *key = [[self->attachements allKeys] objectAtIndex:attachmentIndex];
			
			if ([key isEqualToString:@"image"]) {
				NSDictionary *attachment = [self->attachements objectForKey:key];
				NSString *link = [attachment objectForKey:@"link"];
				if (link) {
					WebPageController *webPageController = [WebPageController create];
					[webPageController goToUrl:link];
					[self presentViewController:webPageController animated:YES completion:nil];
				}
			} else if ([key isEqualToString:@"link"]) {
				NSDictionary *attachment = [self->attachements objectForKey:key];
				NSString *link = [attachment objectForKey:@"url"];
				if (link) {
					WebPageController *webPageController = [WebPageController create];
					[webPageController goToUrl:link];
					[self presentViewController:webPageController animated:YES completion:nil];
				}
			} else if ([key isEqualToString:@"table"]) {
				NSArray *attachment = [self->attachements objectForKey:key];
				ViewAttachedTableController *viewAttachedTableController = [[ViewAttachedTableController alloc] initWithNibName:@"ViewAttachedTableController" bundle:nil];
				[viewAttachedTableController setAttachedTable:attachment];
				[[self navigationController] pushViewController:viewAttachedTableController animated:YES];
				[viewAttachedTableController release];
			} else if ([key isEqualToString:@"map"]) {
				NSDictionary *attachment = [self->attachements objectForKey:key];
				ViewAttachedMapController *viewAttachedMapController = [[ViewAttachedMapController alloc] init];
				[viewAttachedMapController setAttachedMap:attachment];
				[[self navigationController] pushViewController:viewAttachedMapController animated:YES];
				[viewAttachedMapController release];
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
	self.messageSegmentedControl = nil;
	self.mailbox = nil;
	self.messageIndex = 0;
	[self.bodyCell removeObserver:self forKeyPath:@"height"];
	self.bodyCell = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	self.messageSegmentedControl = nil;
	self.mailbox = nil;
	self.messageIndex = 0;
	[self.bodyCell removeObserver:self forKeyPath:@"height"];
	self.bodyCell = nil;
	self.messageId = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (IBAction)archiveMessage {
	self->isArchiving = YES;
	self->isResending = NO;

	UIActionSheet *actionSheet;
    if ([self.mailbox canArchive] && [self.mailbox canTrash]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Archive or Trash this message?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Trash" otherButtonTitles:@"Archive", nil];
    } else if ([self.mailbox canArchive]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Archive this message?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Archive", nil];
    } else if ([self.mailbox canTrash]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Trash this message?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Trash" otherButtonTitles:nil];
    } else {
        actionSheet = nil;
    }
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
}


- (IBAction)resendMessage {
	self->isArchiving = NO;
	self->isResending = YES;
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Reply", @"Forward", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
}

- (IBAction)replyToMessage {
	NewMailMessageController *newMailMessageController = [NewMailMessageController create];
	newMailMessageController.replyToMessage = self.mailbox.messageDetails;
	[[self navigationController] pushViewController:newMailMessageController animated:YES];
}


- (IBAction)forwardMessage {
	NewMailMessageController *newMailMessageController = [NewMailMessageController create];
	newMailMessageController.forwardMessage = self.mailbox.messageDetails;
	[[self navigationController] pushViewController:newMailMessageController animated:YES];
}


- (IBAction)newMessage {
	NewMailMessageController *newMailMessageController = [NewMailMessageController create];
	[[self navigationController] pushViewController:newMailMessageController animated:YES];
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (self->isArchiving) {
        if (actionSheet.cancelButtonIndex == buttonIndex ) {
            //DO NOTHING
		} else if (actionSheet.destructiveButtonIndex == buttonIndex ) {
			[self.mailbox trashMessage:self.messageIndex];
			[self.navigationController popViewControllerAnimated:YES];
		} else {
			[self.mailbox archiveMessage:self.messageIndex];
			[self.navigationController popViewControllerAnimated:YES];
        }

	} else if (self->isResending) {
		switch (buttonIndex) {
			case REPLY_TO_BUTTON_INDEX: //Archive
				[self replyToMessage];
				break;
			case FORWARD_BUTTON_INDEX:
				[self forwardMessage];
				break;
		}
	}
	self->isArchiving = NO;
	self->isResending = NO;
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( [keyPath isEqualToString:@"messageDetails"]) {
		self.navigationItem.title = [self.mailbox.messageDetails objectForKey:@"subject"];
		self->attachements = [self.mailbox.messageDetails objectForKey:@"attachments"];
		self->hasAttachements = isNotNull(self->attachements) && ([self->attachements count] > 0);
		if (self->hasAttachements) {
			self.sectionHeaders = _array([NSNull null],
										 [LEViewSectionTab tableView:self.tableView withText:@"Attachements"],
										 [NSNull null]);
		} else {
			self.sectionHeaders = [NSMutableArray array];
		}
		
		
		if (self.messageIndex <= 0) {
			[self.messageSegmentedControl setEnabled:[self.mailbox hasPreviousPage] forSegmentAtIndex:0];
		} else {
			[self.messageSegmentedControl setEnabled:YES forSegmentAtIndex:0];
		}
		
		if (self.messageIndex >= ([self.mailbox.messageHeaders count]-1)) {
			[self.messageSegmentedControl setEnabled:[self.mailbox hasNextPage] forSegmentAtIndex:1];
		} else {
			[self.messageSegmentedControl setEnabled:YES forSegmentAtIndex:1];
		}
		
		[self.bodyCell setContent:[self.mailbox.messageDetails objectForKey:@"body"] ];

		[self.tableView reloadData];
	} else if ( [keyPath isEqualToString:@"messageHeaders"]) {
		if (!self.messageId) {
			[self.mailbox loadMessage:self.messageIndex];
		}
	} else if ( [keyPath isEqualToString:@"height"]) {
		[self.tableView reloadData];
	}

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
#pragma mark Action Methods

- (void) switchMessage {
	switch (self.messageSegmentedControl.selectedSegmentIndex) {
		case 0:
			self.messageIndex--;
			if (self.messageIndex < 0) {
				self.messageIndex = 24;
				[self.mailbox previousPage];
			} else {
				[self.mailbox loadMessage:self.messageIndex];
			}
			break;
		case 1:
			self.messageIndex++;
			if (self.messageIndex > ([self.mailbox.messageHeaders count]-1)) {
				self.messageIndex = 0;
				[self.mailbox nextPage];
			} else {
				[self.mailbox loadMessage:self.messageIndex];
			}
			
			break;
		default:
			NSLog(@"Invalid switchMessage");
			break;
	}
}

#pragma mark -
#pragma mark Callback Methods

- (void)voteCast:(LEBuildingCastVote *)request {
    if (![request wasError]) {
        NSString *msg = [NSString stringWithFormat:@"The vote needs %@ votes to pass. Current Votes Yes: %@, No: %@", [request.proposition objectForKey:@"votes_needed"], [request.proposition objectForKey:@"votes_yes"], [request.proposition objectForKey:@"votes_no"]];
		
		UIAlertController *av = [UIAlertController alertControllerWithTitle:@"Vote Cast!" message:msg preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
							 { [av dismissViewControllerAnimated:YES completion:nil]; }];
		[av addAction: ok];
		[self presentViewController:av animated:YES completion:nil];
    }
}


#pragma mark -
#pragma mark Class Methods

+ (ViewMailMessageWebController *)create {
	return [[[ViewMailMessageWebController alloc] init] autorelease];
}


@end

