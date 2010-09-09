//
//  ViewMailMessageController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMailMessageController.h"
#import "LEMacros.h"
#import "Mailbox.h"
#import "LEViewSectionTab.h"
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellMailHeaders.h"
#import "LETableViewCellParagraph.h"
#import "LETableViewCellButton.h"
#import "LETableViewCellAttachedImage.h"
#import "LETableViewCellAttachedLink.h"
#import "ViewAttachedTableController.h"
#import "ViewAttachedMapController.h"
#import "NewMailMessageController.h"
#import "WebPageController.h"


typedef enum {
	SECTION_HEADERS,
	SECTION_ATTACHEMENTS,
	SECTION_BODY
} SECTIONS;


@implementation ViewMailMessageController


@synthesize messageSegmentedControl;
@synthesize mailbox;
@synthesize messageIndex;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"Loading";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.messageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.messageSegmentedControl addTarget:self action:@selector(switchMessage) forControlEvents:UIControlEventValueChanged]; 
	self.messageSegmentedControl.momentary = YES;
	self.messageSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.messageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	UIBarButtonItem *fixed = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
	fixed.width = 10;
	
	self.toolbarItems = [NSArray arrayWithObjects:
						 fixed,
						 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(archiveMessage)] autorelease],
						 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
						 [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(replyToMessage)] autorelease],
						 fixed,
						 nil];

	self.sectionHeaders = _array([LEViewSectionTab tableView:self.tableView withText:@"Header"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Attachements"],
								 [LEViewSectionTab tableView:self.tableView withText:@"Message"]);
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.mailbox addObserver:self forKeyPath:@"messageDetails" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	[self.mailbox addObserver:self forKeyPath:@"messageHeaders" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	isObserving = YES;
	[self.mailbox loadMessage:self.messageIndex];
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
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case SECTION_HEADERS:
			return 1;
			break;
		case SECTION_ATTACHEMENTS:
			; //DO NOT REMOVE
			NSDictionary *attachements = [self.mailbox.messageDetails objectForKey:@"attachments"];
			if (isNotNull(attachements)) {
				return [attachements count];
			} else {
				return 1;
			}

			break;
		case SECTION_BODY:
			return 1;
			break;
		default:
			return 0;
			break;
	}
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case SECTION_HEADERS:
			; //DO NOT REMOVE
			return [LETableViewCellMailHeaders getHeightForTableView:tableView];
			break;
		case SECTION_ATTACHEMENTS:
			; //DO NOT REMOVE
			NSDictionary *attachements = [self.mailbox.messageDetails objectForKey:@"attachments"];
			if (isNotNull(attachements)) {
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
				return [LETableViewCellLabeledText getHeightForTableView:tableView];
			}

			break;
		case SECTION_BODY:
			; //DO NOT REMOVE
			NSString *body = [self.mailbox.messageDetails objectForKey:@"body"];
			return [LETableViewCellParagraph getHeightForTableView:tableView text:body];
			break;
		default:
			return 0.0;
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case SECTION_HEADERS:
			; //DO NOT REMOVE
			LETableViewCellMailHeaders *headersCell = [LETableViewCellMailHeaders getCellForTableView:tableView];
			[headersCell setMessage:self.mailbox.messageDetails];
			cell = headersCell;
			break;
		case SECTION_ATTACHEMENTS:
			; //DO NOT REMOVE
			NSDictionary *attachements = [self.mailbox.messageDetails objectForKey:@"attachments"];
			if (isNotNull(attachements)) {
				NSInteger attachmentIndex = indexPath.row;
				NSString *key = [[attachements allKeys] objectAtIndex:attachmentIndex];
				
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
				LETableViewCellLabeledText *noAttachementsCell = [LETableViewCellLabeledText getCellForTableView:tableView isSelectable:NO];
				noAttachementsCell.label.text = @"Attachements";
				noAttachementsCell.content.text = @"None";
				cell = noAttachementsCell;
			}

			break;
		case SECTION_BODY:
			; //DO NOT REMOVE
			LETableViewCellParagraph *bodyCell = [LETableViewCellParagraph getCellForTableView:tableView];
			NSString *body = [self.mailbox.messageDetails objectForKey:@"body"];
			if (body) {
				bodyCell.content.text = body;
			} else {
				bodyCell.content.text = @"Loading";
			}
			bodyCell.content.textColor = MAIL_TEXT_COLOR;
			cell = bodyCell;
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
	switch (indexPath.section) {
		case SECTION_ATTACHEMENTS:
			; //DO NOT REMOVE
			NSDictionary *attachements = [self.mailbox.messageDetails objectForKey:@"attachments"];
			if (isNotNull(attachements)) {
				NSInteger attachmentIndex = indexPath.row;
				NSString *key = [[attachements allKeys] objectAtIndex:attachmentIndex];
				
				if ([key isEqualToString:@"image"]) {
					NSDictionary *attachment = [attachements objectForKey:key];
					NSString *link = [attachment objectForKey:@"link"];
					if (link) {
						[[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
					}
				} else if ([key isEqualToString:@"link"]) {
					NSDictionary *attachment = [attachements objectForKey:key];
					NSString *link = [attachment objectForKey:@"url"];
					if (link) {
						WebPageController *webPageController = [WebPageController create];
						[webPageController goToUrl:link];
						[self presentModalViewController:webPageController animated:YES];
					}
				} else if ([key isEqualToString:@"table"]) {
					NSArray *attachment = [attachements objectForKey:key];
					NSLog(@"Table: %@", attachment);
					ViewAttachedTableController *viewAttachedTableController = [[ViewAttachedTableController alloc] initWithNibName:@"ViewAttachedTableController" bundle:nil];
					[viewAttachedTableController setAttachedTable:attachment];
					[[self navigationController] pushViewController:viewAttachedTableController animated:YES];
					[viewAttachedTableController release];
				} else if ([key isEqualToString:@"map"]) {
					NSDictionary *attachment = [attachements objectForKey:key];
					ViewAttachedMapController *viewAttachedMapController = [[ViewAttachedMapController alloc] init];
					[viewAttachedMapController setAttachedMap:attachment];
					[[self navigationController] pushViewController:viewAttachedMapController animated:YES];
					[viewAttachedMapController release];
				}
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
	self.messageSegmentedControl = nil;
	self.mailbox = nil;
	self.messageIndex = 0;
    [super viewDidUnload];
}


- (void)dealloc {
	self.messageSegmentedControl = nil;
	self.mailbox = nil;
	self.messageIndex = 0;
    [super dealloc];
}


#pragma mark -
#pragma mark Action Methods

- (void)archiveMessage {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Archive message?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
}


- (void)replyToMessage {
	NewMailMessageController *newMailMessageController = [NewMailMessageController create];
	newMailMessageController.replyToMessage = self.mailbox.messageDetails;
	[[self navigationController] pushViewController:newMailMessageController animated:YES];
}


#pragma mark -
#pragma mark UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.destructiveButtonIndex == buttonIndex ) {
		[self.mailbox archiveMessage:self.messageIndex];
		[self.navigationController popViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( [keyPath isEqual:@"messageDetails"]) {
		self.navigationItem.title = [self.mailbox.messageDetails objectForKey:@"subject"];
		
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
		
		[self.tableView reloadData];
	} else if ( [keyPath isEqual:@"messageHeaders"]) {
		[self.mailbox loadMessage:self.messageIndex];
	}
	
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
#pragma mark Class Methods

+ (ViewMailMessageController *)create {
	return [[[ViewMailMessageController alloc] init] autorelease];
}


@end

