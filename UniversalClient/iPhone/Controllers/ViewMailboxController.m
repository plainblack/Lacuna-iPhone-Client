//
//  ViewMailboxController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMailboxController.h"
#import "LEMacros.h"
#import "Mailbox.h"
#import "Session.h"
#import "ViewMailMessageController.h"
#import "NewMailMessageController.h"
#import "LETableViewCellMailSelect.h"


@implementation ViewMailboxController


@synthesize pageSegmentedControl;
@synthesize mailboxSegmentedControl;
@synthesize inboxBarButtonItems;
@synthesize otherMailboxBarButtonItems;
@synthesize mailbox;
@synthesize reloadTimer;
@synthesize lastMessageAt;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.navigationController setToolbarHidden:NO animated:NO];
	[self.navigationController.toolbar setTintColor:TINT_COLOR];

	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadMessages)] autorelease];
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	self.pageSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	UIBarButtonItem *trash = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(toggleEdit)] autorelease];
	UIBarButtonItem	*compose = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessage)] autorelease];
	UIBarButtonItem *flexable = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	UIBarButtonItem *fixed = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
	UIBarButtonItem *trash_placeholder = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
	trash_placeholder.width = 25.0;
	self.mailboxSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(@"Inbox", @"Archived", @"Sent")] autorelease]; 
	[self.mailboxSegmentedControl addTarget:self action:@selector(switchMailBox) forControlEvents:UIControlEventValueChanged]; 
	self.mailboxSegmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	self.mailboxSegmentedControl.tintColor = TINT_COLOR;
	UIBarButtonItem *mailboxChooser = [[[UIBarButtonItem alloc] initWithCustomView:self.mailboxSegmentedControl] autorelease];
	
	fixed.width = 10.0;
	
	self.inboxBarButtonItems = _array(fixed, trash, flexable, mailboxChooser, flexable, compose, fixed);
	self.otherMailboxBarButtonItems = _array(fixed, trash_placeholder, flexable, mailboxChooser, flexable, compose, fixed);

	self.toolbarItems = self.inboxBarButtonItems;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (self.mailboxSegmentedControl.selectedSegmentIndex == UISegmentedControlNoSegment) {
		self.mailboxSegmentedControl.selectedSegmentIndex = 0;
	} else {
		[self.pageSegmentedControl setEnabled:[self.mailbox hasPreviousPage] forSegmentAtIndex:0];
		[self.pageSegmentedControl setEnabled:[self.mailbox hasNextPage] forSegmentAtIndex:1];
		[self.tableView reloadData];
	}
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.mailbox addObserver:self forKeyPath:@"messageHeaders" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	Session *session = [Session sharedInstance];
	if (self.lastMessageAt) {
		if ([self.lastMessageAt compare:session.empire.lastMessageAt] != NSOrderedSame) {
			[self loadMessages];
			self.lastMessageAt = session.empire.lastMessageAt;
			[self.tableView reloadData];
		}
	}else {
		self.lastMessageAt = session.empire.lastMessageAt;
	}
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.reloadTimer invalidate];
	self.reloadTimer = nil;
	[self.mailbox removeObserver:self forKeyPath:@"messageHeaders"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mailbox.messageHeaders count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [LETableViewCellMailSelect getHeightForTableView:tableView];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *message = [self.mailbox.messageHeaders objectAtIndex:indexPath.row];

	LETableViewCellMailSelect *cell = [LETableViewCellMailSelect getCellForTableView:tableView];
	[cell setMessage:message];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete && [self.mailbox canArchive]) {
		[mailbox archiveMessage:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ViewMailMessageController *viewMailMessageController = [[ViewMailMessageController alloc] initWithNibName:@"ViewMailMessageController" bundle:nil];
	viewMailMessageController.mailbox = self.mailbox;
	viewMailMessageController.messageIndex = indexPath.row;
	[[self navigationController] pushViewController:viewMailMessageController animated:YES];
	[viewMailMessageController release];
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
	self.pageSegmentedControl = nil;
	self.mailboxSegmentedControl = nil;
	self.inboxBarButtonItems = nil;
	self.otherMailboxBarButtonItems = nil;
	self.mailbox = nil;
	self.lastMessageAt = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)clear {
	self.mailbox = nil;
	self.lastMessageAt = nil;
	self.mailboxSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark Action Methods


- (void) switchMailBox {
	[self.tableView setEditing:NO animated:YES];
	[self loadMessages];
	[self.tableView reloadData];
}


- (void) switchPage {
	switch (self.pageSegmentedControl.selectedSegmentIndex) {
		case 0:
			[self.mailbox previousPage];
			break;
		case 1:
			[self.mailbox nextPage];
			break;
		default:
			NSLog(@"Invalid switchPage");
			break;
	}
}


- (void)loadMessages {
	if (self.mailbox) {
		[self.mailbox removeObserver:self forKeyPath:@"messageHeaders"];
	}
	
	switch (self.mailboxSegmentedControl.selectedSegmentIndex) {
		case 0:
			self.navigationItem.title = @"Inbox";
			self.mailbox = [Mailbox loadInbox];
			break;
		case 1:
			self.navigationItem.title = @"Archived";
			self.mailbox = [Mailbox loadArchived];
			break;
		case 2:
			self.navigationItem.title = @"Sent";
			self.mailbox = [Mailbox loadSent];
			break;
		default:
			NSLog(@"IN VALID selectedSegmentIndex");
			break;
	}
	
	[self.mailbox addObserver:self forKeyPath:@"messageHeaders" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	
	if ([self.mailbox canArchive]) {
		[self setToolbarItems:self.inboxBarButtonItems animated:NO];
	} else {
		[self setToolbarItems:self.otherMailboxBarButtonItems animated:NO];
	}
}


- (void)toggleEdit {
	[self.tableView setEditing:![self.tableView isEditing] animated:YES];
}


- (void)newMessage {
	NewMailMessageController *newMailMessageController = [NewMailMessageController create];
	[[self navigationController] pushViewController:newMailMessageController animated:YES];
}


#pragma mark -
#pragma mark KVO Methods


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( [keyPath isEqual:@"messageHeaders"]) {
		[self.pageSegmentedControl setEnabled:[self.mailbox hasPreviousPage] forSegmentAtIndex:0];
		[self.pageSegmentedControl setEnabled:[self.mailbox hasNextPage] forSegmentAtIndex:1];
		[self.tableView reloadData];
	}
}


#pragma mark -
#pragma mark Timer Callback


- (void)handleTimer:(NSTimer *)theTimer {
	NSLog(@"handleTimer");
	if (theTimer == self.reloadTimer) {
		[self.mailbox loadMessageHeaders];
	}
}


@end

