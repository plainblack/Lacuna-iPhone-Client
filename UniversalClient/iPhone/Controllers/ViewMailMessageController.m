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
#import "LETableViewCellLabeledText.h"
#import "LETableViewCellParagraph.h"
#import "NewMailMessageController.h"
#import "LETableViewCellAttachedImage.h"
#import "LETableViewCellAttachedLink.h"
#import "LETableViewCellButton.h"
#import "ViewAttachedTableController.h"


typedef enum {
	ROW_FROM,
	ROW_TO,
	ROW_SUBJECT,
	ROW_BODY
} ROW;


@interface ViewMailMessageController (PrivateMethods)
- (CGFloat)heightForCellWithText:(NSString *)theText inFrame:(CGRect)aFrame;
@end


@implementation ViewMailMessageController


@synthesize messageSegmentedControl;
@synthesize mailbox;
@synthesize messageIndex;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	self.navigationItem.title = @"Loading";
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	
	self.messageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:array_([UIImage imageNamed:@"/assets/ui/up.png"], [UIImage imageNamed:@"/assets/ui/down.png"])] autorelease];
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

	numRows = 4;
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
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return numRows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case ROW_FROM:
			; //DO NOT REMOVE
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case ROW_TO:
			; //DO NOT REMOVE
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case ROW_SUBJECT:
			; //DO NOT REMOVE
			return [LETableViewCellLabeledText getHeightForTableView:tableView];
			break;
		case ROW_BODY:
			; //DO NOT REMOVE
			CGFloat rowHeight = tableView.rowHeight;
			NSString *body = [self.mailbox.messageDetails objectForKey:@"body"];
			tableView.rowHeight = tableView.bounds.size.height;
			CGFloat height = [LETableViewCellParagraph getHeightForTableView:tableView text:body];
			tableView.rowHeight = rowHeight;
			return height;
			break;
		default:
			; //DO NOT REMOVE
			NSDictionary *attachements = [self.mailbox.messageDetails objectForKey:@"attachments"];
			
			NSInteger attachmentIndex = indexPath.row - 4;
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
				NSLog(@"INVALID ATTACHMENT");
				return tableView.rowHeight;
			}
			break;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.row) {
		case ROW_FROM:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *fromCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			fromCell.label.text = @"To";
			fromCell.content.text = [self.mailbox.messageDetails objectForKey:@"to"];
			cell = fromCell;
			break;
		case ROW_TO:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *toCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			toCell.label.text = @"From";
			toCell.content.text = [self.mailbox.messageDetails objectForKey:@"from"];
			cell = toCell;
			break;
		case ROW_SUBJECT:
			; //DO NOT REMOVE
			LETableViewCellLabeledText *subjectCell = [LETableViewCellLabeledText getCellForTableView:tableView];
			subjectCell.label.text = @"Subject";
			subjectCell.content.text = [self.mailbox.messageDetails objectForKey:@"subject"];
			cell = subjectCell;
			break;
		case ROW_BODY:
			; //DO NOT REMOVE
			LETableViewCellParagraph *bodyCell = [LETableViewCellParagraph getCellForTableView:tableView];
			NSString *body = [self.mailbox.messageDetails objectForKey:@"body"];
			if (body) {
				bodyCell.content.text = body;
			} else {
				bodyCell.content.text = @"Loading";
			}
			cell = bodyCell;
			break;
		default:
			; //DO NOT REMOVE
			NSDictionary *attachements = [self.mailbox.messageDetails objectForKey:@"attachments"];
			
			NSInteger attachmentIndex = indexPath.row - 4;
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
				NSLog(@"INVALID ATTACHMENT");
			}
			break;
	}
	
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *attachements = [self.mailbox.messageDetails objectForKey:@"attachments"];
	NSInteger attachmentIndex = indexPath.row - 4;
	NSString *key = [[attachements allKeys] objectAtIndex:attachmentIndex];
	
	if ([key isEqualToString:@"image"]) {
		NSDictionary *attachment = [attachements objectForKey:key];
		NSString *link = [attachment objectForKey:@"link"];
		if (link) {
			NSLog(@"KEVIN MAKE THIS GO TO: %@", link);
		}
	} else if ([key isEqualToString:@"link"]) {
		NSDictionary *attachment = [attachements objectForKey:key];
		NSString *link = [attachment objectForKey:@"url"];
		if (link) {
			NSLog(@"KEVIN MAKE THIS GO TO: %@", link);
		}
	} else if ([key isEqualToString:@"table"]) {
		NSArray *attachment = [attachements objectForKey:key];
		NSLog(@"Table: %@", attachment);
		ViewAttachedTableController *viewAttachedTableController = [[ViewAttachedTableController alloc] initWithNibName:@"ViewAttachedTableController" bundle:nil];
		[viewAttachedTableController setAttachedTable:attachment];
		[[self navigationController] pushViewController:viewAttachedTableController animated:YES];
		[viewAttachedTableController release];
	} else if ([key isEqualToString:@"map"]) {
		NSLog(@"KEVIN MAKE THIS GO TO A VIEW ONLY MAP!");
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	self.messageSegmentedControl = nil;
	self.mailbox = nil;
	self.messageIndex = 0;
}


- (void)dealloc {
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
		
		NSDictionary *attachements = [self.mailbox.messageDetails objectForKey:@"attachments"];
		
		if (attachements) {
			numRows = 4 + [attachements count];
		} else {
			numRows = 4;
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


@end

