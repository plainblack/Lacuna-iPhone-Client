//
//  ViewMailboxController.m
//  UniversalClient
//
//  Created by Kevin Runde on 4/17/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "ViewMailboxController.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"
#import "Mailbox.h"
#import "ViewMailMessageWebController.h"
#import "NewMailMessageController.h"
#import "LETableViewCellMailSelect.h"


@implementation ViewMailboxController


@synthesize pageSegmentedControl;
@synthesize mailboxFilterBarButtonItem;
@synthesize viewingBarButtonItems;
@synthesize editingBarButtonItems;
@synthesize editBarButtonItem;
@synthesize archiveOrTrashBarButtonItem;
@synthesize mailbox;
@synthesize reloadTimer;
@synthesize lastMessageAt;
@synthesize showMessageId;
@synthesize selectedMessageIds;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    if (self->mailboxType == LEMailboxTypeNone) {
        self->mailboxType = LEMailboxTypeInbox;
        self->mailboxFilterType = LEMailboxFilterTypeNone;
    }
    [super viewDidLoad];
    self.tableView.allowsSelectionDuringEditing = YES;
	
    if (isNull(self.selectedMessageIds)) {
        self.selectedMessageIds = [NSMutableSet setWithCapacity:25];
    }

	self->observingMailbox = NO;

	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.navigationController.toolbar setTintColor:TINT_COLOR];

    self.navigationItem.title = nil;
	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    self.mailboxFilterBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStylePlain target:self action:@selector(showSelectMailbox)] autorelease];
    self.navigationItem.leftBarButtonItem = self.mailboxFilterBarButtonItem;
	
	self.pageSegmentedControl = [[[UISegmentedControl alloc] initWithItems:_array(UP_ARROW_ICON, DOWN_ARROW_ICON)] autorelease];
	[self.pageSegmentedControl addTarget:self action:@selector(switchPage) forControlEvents:UIControlEventValueChanged]; 
	self.pageSegmentedControl.momentary = YES;
	UIBarButtonItem *rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.pageSegmentedControl] autorelease];
	self.navigationItem.rightBarButtonItem = rightBarButtonItem; 
	
	self.editBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Archive/Trash" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)] autorelease];
	UIBarButtonItem *cancelBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)] autorelease];
	self.archiveOrTrashBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Archive/Trash (0)" style:UIBarButtonItemStyleDone target:self action:@selector(archiveSelected:)] autorelease];
	UIBarButtonItem	*composeBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessage)] autorelease];
	UIBarButtonItem *flexableBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	UIBarButtonItem *fixedBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
	fixedBarButtonItem.width = 10.0;
	self.viewingBarButtonItems = _array(fixedBarButtonItem, self.editBarButtonItem, flexableBarButtonItem, composeBarButtonItem, fixedBarButtonItem);
	self.editingBarButtonItems = _array(fixedBarButtonItem, cancelBarButtonItem, flexableBarButtonItem, self.archiveOrTrashBarButtonItem, fixedBarButtonItem);

	self.toolbarItems = self.viewingBarButtonItems;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	[self.navigationController setToolbarHidden:NO animated:NO];

    if (isNull(self.mailbox.messageHeaders)) {
        [self loadMessages];
    } else {
        [self.pageSegmentedControl setEnabled:[self.mailbox hasPreviousPage] forSegmentAtIndex:0];
        [self.pageSegmentedControl setEnabled:[self.mailbox hasNextPage] forSegmentAtIndex:1];
        [self.tableView reloadData];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	if (!self->observingMailbox) {
		[self.mailbox addObserver:self forKeyPath:@"messageHeaders" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
		self->observingMailbox = YES;
	}
	self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:600 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
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
	if (!self->observingLastMessageAt) {
		[session.empire addObserver:self forKeyPath:@"lastMessageAt" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
		self->observingLastMessageAt = YES;
	}
	
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
	[self.reloadTimer invalidate];
	self.reloadTimer = nil;
	[self.mailbox removeObserver:self forKeyPath:@"messageHeaders"];
	self->observingMailbox = NO;
	Session *session = [Session sharedInstance];
	if (self->observingLastMessageAt) {
		[session.empire removeObserver:self forKeyPath:@"lastMessageAt"];
		self->observingLastMessageAt = NO;
	}
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
    NSString *messageId = [Util idFromDict:message named:@"id"];

	LETableViewCellMailSelect *cell = [LETableViewCellMailSelect getCellForTableView:tableView];
    if ([self.selectedMessageIds containsObject:messageId]) {
        [cell selectForDelete];
    } else {
        [cell unselectForDelete];
    }
	[cell setMessage:message];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete && [self.mailbox canArchive]) {
        NSString *messageId = [Util idFromDict:[self.mailbox.messageHeaders objectAtIndex:indexPath.row] named:@"id"];
        [self.selectedMessageIds addObject:messageId];
        [self archiveOrTrash];
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!tableView.editing) {
        [self.mailbox addObserver:self forKeyPath:@"messageHeaders" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
        //ViewMailMessageController *viewMailMessageController = [ViewMailMessageController create];
        ViewMailMessageWebController *viewMailMessageController = [ViewMailMessageWebController create];
        viewMailMessageController.mailbox = self.mailbox;
        viewMailMessageController.messageIndex = indexPath.row;
        
        [[self navigationController] pushViewController:viewMailMessageController animated:YES];
    } else {
        NSString *messageId = [Util idFromDict:[self.mailbox.messageHeaders objectAtIndex:indexPath.row] named:@"id"];
        if ([self.selectedMessageIds containsObject:messageId]) {
            [self.selectedMessageIds removeObject:messageId];
            [(LETableViewCellMailSelect *)[self.tableView cellForRowAtIndexPath:indexPath] unselectForDelete];
        } else {
            [self.selectedMessageIds addObject:messageId];
            [(LETableViewCellMailSelect *)[self.tableView cellForRowAtIndexPath:indexPath] selectForDelete];
        }
        [self updateSelectionCount];
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.mailbox canArchive] && [self.mailbox canTrash]) {
        return @"Archive/Trash";
    } else if ([self.mailbox canArchive]) {
        return @"Archive";
    } else if ([self.mailbox canTrash]) {
        return @"Trash";
    } else {
        return @"Cannot Delete";
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
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
	self.pageSegmentedControl = nil;
    self.mailboxFilterBarButtonItem = nil;
	self.viewingBarButtonItems = nil;
	self.editingBarButtonItems = nil;
    self.editBarButtonItem = nil;
    self.archiveOrTrashBarButtonItem = nil;
	self.mailbox = nil;
	self.lastMessageAt = nil;
    [super viewDidUnload];
}


- (void)dealloc {
	[self.reloadTimer invalidate];
	self.reloadTimer = nil;
	self.pageSegmentedControl = nil;
    self.mailboxFilterBarButtonItem = nil;
	self.viewingBarButtonItems = nil;
	self.editingBarButtonItems = nil;
    self.editBarButtonItem = nil;
    self.archiveOrTrashBarButtonItem = nil;
	self.mailbox = nil;
	self.lastMessageAt = nil;
	self.showMessageId = nil;
    self.selectedMessageIds = nil;
    [super dealloc];
}


#pragma mark - PullRefreshTableViewController Methods

- (void)refresh {
    [self loadMessages];
}


#pragma mark -
#pragma mark Instance Methods

- (void)clear {
	self.mailbox = nil;
	self.lastMessageAt = nil;
	[self.tableView reloadData];
}


- (void)showMessageById:(NSString *)messageId {
	if (self.mailbox) {
		ViewMailMessageWebController *viewMailMessageController = [ViewMailMessageWebController create];
		viewMailMessageController.mailbox = self.mailbox;
		viewMailMessageController.messageId = messageId;
		
		[[self navigationController] pushViewController:viewMailMessageController animated:YES];
	} else {
		NSLog(@"No mailbox yet.");
		self.showMessageId = messageId;
	}
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
    if (self->observingMailbox) {
        [self.mailbox removeObserver:self forKeyPath:@"messageHeaders"];
        self->observingMailbox = NO;
    }
	
    [self setMailboxFilterName];
    switch (self->mailboxType) {
        case LEMailboxTypeInbox:
            self.mailbox = [Mailbox loadInboxWithFilter:self->mailboxFilterType];
            break;
        case LEMailboxTypeArchived:
            self.mailbox = [Mailbox loadArchivedWithFilter:self->mailboxFilterType];
            break;
        case LEMailboxTypeTrash:
            self.mailbox = [Mailbox loadTrashWithFilter:self->mailboxFilterType];
            break;
        case LEMailboxTypeSent:
            self.mailbox = [Mailbox loadSentWithFilter:self->mailboxFilterType];
            break;
        default:
            break;
    }
    
    if ([self.mailbox canArchive] && [self.mailbox canTrash]) {
        self.editBarButtonItem.title = @"Archive/Trash";
        self.editBarButtonItem.enabled = YES;
    } else if ([self.mailbox canArchive]) {
        self.editBarButtonItem.title = @"Archive";
        self.editBarButtonItem.enabled = YES;
    } else if ([self.mailbox canTrash]) {
        self.editBarButtonItem.title = @"Trash";
        self.editBarButtonItem.enabled = YES;
    } else {
        self.editBarButtonItem.title = @"Cannot Delete";
        self.editBarButtonItem.enabled = NO;
    }
	
	if (!self->observingMailbox) {
		[self.mailbox addObserver:self forKeyPath:@"messageHeaders" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
		self->observingMailbox = YES;
	}
	
	if (self.showMessageId) {
		ViewMailMessageWebController *viewMailMessageController = [ViewMailMessageWebController create];
		viewMailMessageController.mailbox = self.mailbox;
		viewMailMessageController.messageId = self.showMessageId;
		self.showMessageId = nil;
		[[self navigationController] pushViewController:viewMailMessageController animated:YES];
	}
    [self stopLoading];
}


- (void)toggleEdit {
	[self.tableView setEditing:![self.tableView isEditing] animated:YES];
}


- (void)newMessage {
	NewMailMessageController *newMailMessageController = [NewMailMessageController create];
	[[self navigationController] pushViewController:newMailMessageController animated:YES];
}


- (IBAction)showSelectMailbox {
    SelectMailboxController *selectMailboxController = [SelectMailboxController create];
    selectMailboxController.delegate = self;
    [self.navigationController pushViewController:selectMailboxController animated:YES];
}

- (IBAction)edit:(id)sender {
    [self.selectedMessageIds removeAllObjects];
    [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LETableViewCellMailSelect *cell = obj;
        [cell unselectForDelete];
    }];
    [self setToolbarItems:self.editingBarButtonItems animated:YES];
    [self.pageSegmentedControl setEnabled:NO forSegmentAtIndex:0];
    [self.pageSegmentedControl setEnabled:NO forSegmentAtIndex:1];
	[self.tableView setEditing:YES animated:YES];
}


- (IBAction)cancel:(id)sender {
    [self setToolbarItems:self.viewingBarButtonItems animated:YES];
    [self.pageSegmentedControl setEnabled:[self.mailbox hasPreviousPage] forSegmentAtIndex:0];
    [self.pageSegmentedControl setEnabled:[self.mailbox hasNextPage] forSegmentAtIndex:1];
	[self.tableView setEditing:NO animated:YES];
}


- (IBAction)trashSelected:(id)sender {
    [self archiveOrTrash];
    [self cancel:sender];
}


- (IBAction)archiveSelected:(id)sender {    
    [self archiveOrTrash];
    [self cancel:sender];
}


- (void)updateSelectionCount {
    if ([self.mailbox canArchive] && [self.mailbox canTrash]) {
        self.archiveOrTrashBarButtonItem.title = [NSString stringWithFormat:@"Archive/Trash (%lu)", (unsigned long)[self.selectedMessageIds count]];
    } else if ([self.mailbox canArchive]) {
        self.archiveOrTrashBarButtonItem.title = [NSString stringWithFormat:@"Archive (%lu)", (unsigned long)[self.selectedMessageIds count]];
    } else if ([self.mailbox canTrash]) {
        self.archiveOrTrashBarButtonItem.title = [NSString stringWithFormat:@"Trash (%lu)", (unsigned long)[self.selectedMessageIds count]];
    } else {
        self.archiveOrTrashBarButtonItem.title = [NSString stringWithFormat:@"Nothing (%lu)", (unsigned long)[self.selectedMessageIds count]];
    }
}


- (void)archiveOrTrash {
    UIActionSheet *actionSheet;
    if ([self.mailbox canArchive] && [self.mailbox canTrash]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do with the selected messages?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Trash" otherButtonTitles:@"Archive", nil];
    } else if ([self.mailbox canArchive]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do with the selected messages?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Archive", nil];
    } else if ([self.mailbox canTrash]) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do with the selected messages?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Trash" otherButtonTitles:nil];
    } else {
        actionSheet = nil;
    }
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
	[actionSheet release];
}

- (void)setMailboxFilterName {
    NSString *mailboxName;
    NSString *filterName;
    
    switch (self->mailboxType) {
        case LEMailboxTypeArchived:
            mailboxName = @"Archive";
            break;
        case LEMailboxTypeInbox:
            mailboxName = @"Inbox";
            break;
        case LEMailboxTypeSent:
            mailboxName = @"Sent";
            break;
        case LEMailboxTypeTrash:
            mailboxName = @"Trash";
            break;
        default:
            mailboxName = @"?";
            break;
    }
    switch (self->mailboxFilterType) {
        case LEMailboxFilterTypeNone:
            filterName = @"All";
            break;
        case LEMailboxFilterTypeAlert:
            filterName = @"Alert";
            break;
        case LEMailboxFilterTypeAttack:
            filterName = @"Attack";
            break;
        case LEMailboxFilterTypeColonization:
            filterName = @"Colonization";
            break;
        case LEMailboxFilterTypeComplaint:
            filterName = @"Complaint";
            break;
        case LEMailboxFilterTypeCorrespondence:
            filterName = @"Correspondence";
            break;
        case LEMailboxFilterTypeExcavator:
            filterName = @"Excavator";
            break;
		case LEMailboxFilterTypeFissure:
			filterName = @"Fissure";
			break;
        case LEMailboxFilterTypeIntelligence:
            filterName = @"Intelligence";
            break;
        case LEMailboxFilterTypeMedal:
            filterName = @"Medal";
            break;
        case LEMailboxFilterTypeMission:
            filterName = @"Mission";
            break;
        case LEMailboxFilterTypeParliament:
            filterName = @"Parliament";
            break;
        case LEMailboxFilterTypeProbe:
            filterName = @"Probe";
            break;
        case LEMailboxFilterTypeSpies:
            filterName = @"Spies";
            break;
        case LEMailboxFilterTypeTrade:
            filterName = @"Trade";
            break;
        case LEMailboxFilterTypeTutorial:
            filterName = @"Tutorial";
            break;
        default:
            filterName = @"?";
            break;
    }
    
    self.mailboxFilterBarButtonItem.title = [NSString stringWithFormat:@"%@ : %@", mailboxName, filterName];
}


#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.cancelButtonIndex == buttonIndex ) {
        NSLog(@"Cancelled");
        //Does nothing
	} else if (actionSheet.destructiveButtonIndex == buttonIndex) {
        NSLog(@"Destructive");
		[self.mailbox trashMessages:self.selectedMessageIds];
        [self.tableView reloadData];
	} else {
        NSLog(@"Archive");
		[self.mailbox archiveMessages:self.selectedMessageIds];
        [self.tableView reloadData];
    }
}


#pragma mark - SelectMailboxControllerDelegate Methods

- (void)selectedMailbox:(LEMailboxType)inMailboxType {
    self->mailboxType = inMailboxType;
    SelectMailboxFilterController *vc = [SelectMailboxFilterController create];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - SelectMailboxFilterControllerDelegate Methods


- (void)selectedMailboxFilter:(LEMailboxFilterType)inMailboxFilterType {
    self->mailboxFilterType = inMailboxFilterType;
    [self.navigationController popToViewController:self animated:YES];
    [self loadMessages];
}


#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( [keyPath isEqual:@"messageHeaders"]) {
		[self.pageSegmentedControl setEnabled:[self.mailbox hasPreviousPage] forSegmentAtIndex:0];
		[self.pageSegmentedControl setEnabled:[self.mailbox hasNextPage] forSegmentAtIndex:1];
		[self.tableView reloadData];
	} else if ([keyPath isEqual:@"lastMessageAt"]) {
		Session *session = [Session sharedInstance];
		if ([self.lastMessageAt compare:session.empire.lastMessageAt] == NSOrderedAscending) {
			[self loadMessages];
			[self.tableView reloadData];
		}
		self.lastMessageAt = session.empire.lastMessageAt;
	}
}


#pragma mark -
#pragma mark Timer Callback

- (void)handleTimer:(NSTimer *)theTimer {
	if (theTimer == self.reloadTimer) {
		[self.mailbox loadMessageHeaders];
	}
}


@end

