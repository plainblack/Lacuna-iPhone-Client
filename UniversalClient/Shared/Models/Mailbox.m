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
	return originalMessageHeaderCount >= MAX_MESSAGES_PER_PAGE;
}


- (BOOL)hasPreviousPage {
	return pageIndex > START_PAGE;
}

- (void)nextPage {
	if ([self hasNextPage]) {
		pageIndex++;
		[self loadMessageHeaders];
	}
}

- (void)previousPage {
	if ([self hasPreviousPage]) {
		pageIndex--;
		[self loadMessageHeaders];
	}
}


- (void)loadMessage:(NSInteger)index {
	self.messageDetails = [self.messageHeaders objectAtIndex:index];
	[self.messageDetails setObject:[NSNumber numberWithInt:1] forKey:@"has_read"];
	Session *session = [Session sharedInstance];
	session.empire.numNewMessages -= 1;
	NSString *messageId = [self.messageDetails objectForKey:@"id"];
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
		NSLog(@"Archive");
		NSDictionary *headers = [self.messageHeaders objectAtIndex:index];
		NSString *messageId = [headers objectForKey:@"id"];
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
			[[[LEInboxViewArchived alloc] initWithCallback:@selector(messagesLoaded:) target:self page:[NSNumber numberWithInt:pageIndex]] autorelease];
			break;
		case LEMailboxTypeInbox:
			[[[LEInboxView alloc] initWithCallback:@selector(messagesLoaded:) target:self page:[NSNumber numberWithInt:pageIndex]] autorelease];
			break;
		case LEMailboxTypeSent:
			[[[LEInboxViewSent alloc] initWithCallback:@selector(messagesLoaded:) target:self page:[NSNumber numberWithInt:pageIndex]] autorelease];
			break;
		default:
			NSLog(@"No LEMailboxType Set");
			break;
	}
}


- (id)messagesLoaded:(LEInboxView *)request {
	if (![request wasError]) {
		originalMessageHeaderCount = [request.messages count];
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
