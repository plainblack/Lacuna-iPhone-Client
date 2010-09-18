//
//  Mailbox.m
//  DKTest
//
//  Created by Kevin Runde on 4/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Mailbox.h"
#import "LEInboxArchive.h"
#import "LEInboxRead.h"
#import "LEInboxView.h"
#import "LEInboxViewSent.h"
#import "LEInboxViewArchived.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"

#define START_PAGE 1
#define MAX_MESSAGES_PER_PAGE 25


@implementation Mailbox


@synthesize messageHeaders;
@synthesize messageDetails;


- (Mailbox *)init:(LEMailBoxType)inLeMailboxType {
	if (self = [super init]) {
		leMailboxType = inLeMailboxType;
		pageIndex = START_PAGE;
		originalMessageHeaderCount = 0;
		[self loadMessageHeaders];
	}
	
	return self;
}


- (void)dealloc {
	self.messageHeaders = nil;
	self.messageDetails = nil;
	
	[super dealloc];
}


- (BOOL)canArchive {
	return leMailboxType == LEMailboxTypeInbox;
}


- (BOOL)hasNextPage {
	return self->pageIndex < self->numPages;
}


- (BOOL)hasPreviousPage {
	return self->pageIndex > START_PAGE;
}

- (void)nextPage {
	if ([self hasNextPage]) {
		self->pageIndex++;
		[self loadMessageHeaders];
	}
}

- (void)previousPage {
	if ([self hasPreviousPage]) {
		self->pageIndex--;
		[self loadMessageHeaders];
	}
}


- (void)loadMessage:(NSInteger)index {
	NSMutableDictionary *messageHeader = [self.messageHeaders objectAtIndex:index];
	if (!_boolv([messageHeader objectForKey:@"has_read"])) {
		[messageHeader setObject:[NSDecimalNumber numberWithInt:1] forKey:@"has_read"];
		Session *session = [Session sharedInstance];
		session.empire.numNewMessages = [session.empire.numNewMessages decimalNumberBySubtracting:[NSDecimalNumber one]];
	}
	[self loadMessageById:[Util idFromDict:messageHeader named:@"id"]];
}


- (void)loadMessageById:(NSString *)messageId {
	if (self.messageDetails) {
		NSString *messageDetailId = [Util idFromDict:self.messageDetails named:@"id"];
		if (![messageDetailId isEqualToString:messageId]) {
			self.messageDetails = nil;
		}
	}
	[[[LEInboxRead alloc] initWithCallback:@selector(messageDetailsLoaded:) target:self messageId:messageId] autorelease];
}


- (id)messageDetailsLoaded:(LEInboxRead *)request {
	if (![request wasError]) {
		self.messageDetails = request.message;
	}
	
	return nil;
}


- (void)archiveMessage:(NSInteger)index {
	if ([self canArchive]) {
		NSDictionary *headers = [self.messageHeaders objectAtIndex:index];
		NSString *messageId = [Util idFromDict:headers named:@"id"];
		[[[LEInboxArchive alloc] initWithCallback:@selector(messageArchived:) target:self messageIds:_array(messageId)] autorelease];
		[self.messageHeaders removeObjectAtIndex:index];
	}
}


- (id)messageArchived:(LEInboxArchive *)request {
	return nil;
}


- (void)loadMessageHeaders {
	//Load Page
	switch (leMailboxType) {
		case LEMailboxTypeArchived:
			[[[LEInboxViewArchived alloc] initWithCallback:@selector(messagesLoaded:) target:self page:[Util decimalFromInt:pageIndex]] autorelease];
			break;
		case LEMailboxTypeInbox:
			[[[LEInboxView alloc] initWithCallback:@selector(messagesLoaded:) target:self page:[Util decimalFromInt:pageIndex]] autorelease];
			break;
		case LEMailboxTypeSent:
			[[[LEInboxViewSent alloc] initWithCallback:@selector(messagesLoaded:) target:self page:[Util decimalFromInt:pageIndex]] autorelease];
			break;
		default:
			NSLog(@"No LEMailboxType Set");
			break;
	}
}


- (id)messagesLoaded:(LEInboxView *)request {
	if (![request wasError]) {
		self->originalMessageHeaderCount = [request.messages count];
		self->numPages = [Util numPagesForCount:_intv(request.messageCount)];
		self.messageHeaders = request.messages;
	}
	
	return nil;
}


+ (Mailbox *)loadArchived {
	return [[[Mailbox alloc] init:LEMailboxTypeArchived] autorelease];
}


+ (Mailbox *)loadInbox {
	return [[[Mailbox alloc] init:LEMailboxTypeInbox] autorelease];
}


+ (Mailbox *)loadSent {
	return [[[Mailbox alloc] init:LEMailboxTypeSent] autorelease];
}


@end
