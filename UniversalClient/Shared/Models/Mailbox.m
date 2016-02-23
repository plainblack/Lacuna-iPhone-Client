//
//  Mailbox.m
//  DKTest
//
//  Created by Kevin Runde on 4/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Mailbox.h"
#import "LEInboxArchive.h"
#import "LEInboxTrash.h"
#import "LEInboxRead.h"
#import "LEInboxView.h"
#import "LEInboxViewSent.h"
#import "LEInboxViewArchived.h"
#import "LEInboxViewTrash.h"
#import "LEMacros.h"
#import "Util.h"
#import "Session.h"

#define START_PAGE 1
#define MAX_MESSAGES_PER_PAGE 25


@implementation Mailbox


@synthesize messageHeaders;
@synthesize messageDetails;


- (Mailbox *)initMailbox:(LEMailboxType)inLeMailboxType filter:(LEMailboxFilterType)inLeMailboxFilterType {
	if ((self = [super init])) {
		self->leMailboxType = inLeMailboxType;
		self->leMailboxFilterType = inLeMailboxFilterType;
		self->pageIndex = START_PAGE;
		self->originalMessageHeaderCount = 0;
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
	return self->leMailboxType == LEMailboxTypeInbox || self->leMailboxType == LEMailboxTypeTrash;
}


- (BOOL)canTrash {
	return self->leMailboxType == LEMailboxTypeInbox || self->leMailboxType == LEMailboxTypeArchived;
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
		[[[LEInboxArchive alloc] initWithCallback:@selector(messagesArchived:) target:self messageIds:_array(messageId)] autorelease];
		[self.messageHeaders removeObjectAtIndex:index];
	}
}


- (void)archiveMessages:(NSSet *)messageIds {
	if ([self canArchive]) {
        NSMutableArray *messageIdArray = [NSMutableArray arrayWithCapacity:[messageIds count]];
        [messageIds enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            [messageIdArray addObject:obj];
        }];
		[[[LEInboxArchive alloc] initWithCallback:@selector(messagesArchived:) target:self messageIds:messageIdArray] autorelease];
        
        [messageIds enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            NSString *toRemoveMessageId = (NSString *)obj;
            __block NSInteger messageHeaderIndex = -1;
            [self.messageHeaders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *messageId = [Util idFromDict:obj named:@"id"];
                if ([messageId isEqualToString:toRemoveMessageId]) {
                    messageHeaderIndex = idx;
                    *stop = YES;
                }
            }];
            if (messageHeaderIndex > -1) {
                [self.messageHeaders removeObjectAtIndex:messageHeaderIndex];
            }
        }];
	}
}


- (void)trashMessage:(NSInteger)index {
	if ([self canArchive]) {
		NSDictionary *headers = [self.messageHeaders objectAtIndex:index];
		NSString *messageId = [Util idFromDict:headers named:@"id"];
		[[[LEInboxTrash alloc] initWithCallback:@selector(messagesTrashed:) target:self messageIds:_array(messageId)] autorelease];
		[self.messageHeaders removeObjectAtIndex:index];
	}
}


- (void)trashMessages:(NSSet *)messageIds {
	if ([self canTrash]) {
        NSMutableArray *messageIdArray = [NSMutableArray arrayWithCapacity:[messageIds count]];
        [messageIds enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            [messageIdArray addObject:obj];
        }];
		[[[LEInboxTrash alloc] initWithCallback:@selector(messagesTrashed:) target:self messageIds:messageIdArray] autorelease];
        
        [messageIds enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            NSString *toRemoveMessageId = (NSString *)obj;
            __block NSInteger messageHeaderIndex = -1;
            [self.messageHeaders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSString *messageId = [Util idFromDict:obj named:@"id"];
                if ([messageId isEqualToString:toRemoveMessageId]) {
                    messageHeaderIndex = idx;
                    *stop = YES;
                }
            }];
            if (messageHeaderIndex > -1) {
                [self.messageHeaders removeObjectAtIndex:messageHeaderIndex];
            }
        }];
	}
}


- (id)messagesArchived:(LEInboxArchive *)request {
	return nil;
}


- (id)messagesTrashed:(LEInboxTrash *)request {
	return nil;
}


- (void)loadMessageHeaders {
	//Load Page
	switch (leMailboxType) {
		case LEMailboxTypeArchived:
			[[[LEInboxViewArchived alloc] initWithCallback:@selector(messagesLoaded:) target:self page:[Util decimalFromInt:pageIndex] tags:[self filterTags]] autorelease];
			break;
		case LEMailboxTypeInbox:
			[[[LEInboxView alloc] initWithCallback:@selector(messagesLoaded:) target:self page:[Util decimalFromInt:pageIndex] tags:[self filterTags]] autorelease];
			break;
		case LEMailboxTypeSent:
			[[[LEInboxViewSent alloc] initWithCallback:@selector(messagesLoaded:) target:self page:[Util decimalFromInt:pageIndex] tags:[self filterTags]] autorelease];
			break;
		case LEMailboxTypeTrash:
			[[[LEInboxViewTrash alloc] initWithCallback:@selector(messagesLoaded:) target:self page:[Util decimalFromInt:pageIndex] tags:[self filterTags]] autorelease];
			break;
		default:
			NSLog(@"No LEMailboxType Set");
			break;
	}
}


- (NSArray *)filterTags {
    switch (self->leMailboxFilterType) {
        case LEMailboxFilterTypeNone:
            return [NSArray array];
            break;
        case LEMailboxFilterTypeAlert:
            return _array(@"Alert");
            break;
        case LEMailboxFilterTypeAttack:
            return _array(@"Attack");
            break;
        case LEMailboxFilterTypeColonization:
            return _array(@"Colonization");
            break;
        case LEMailboxFilterTypeComplaint:
            return _array(@"Complaint");
            break;
        case LEMailboxFilterTypeCorrespondence:
            return _array(@"Correspondence");
            break;
        case LEMailboxFilterTypeExcavator:
            return _array(@"Excavator");
            break;
		case LEMailboxFilterTypeFissure:
			return _array(@"Fissure");
			break;
        case LEMailboxFilterTypeIntelligence:
            return _array(@"Intelligence");
            break;
        case LEMailboxFilterTypeMedal:
            return _array(@"Medal");
            break;
        case LEMailboxFilterTypeMission:
            return _array(@"Mission");
            break;
        case LEMailboxFilterTypeParliament:
            return _array(@"Parliament");
            break;
        case LEMailboxFilterTypeProbe:
            return _array(@"Probe");
            break;
        case LEMailboxFilterTypeSpies:
            return _array(@"Spies");
            break;
        case LEMailboxFilterTypeTrade:
            return _array(@"Trade");
            break;
        case LEMailboxFilterTypeTutorial:
            return _array(@"Tutorial");
            break;
        default:
            return nil;
            break;
    }
}


#pragma mark - Callback Methods

- (id)messagesLoaded:(LEInboxView *)request {
	if (![request wasError]) {
		self->originalMessageHeaderCount = [request.messages count];
		self->numPages = [Util numPagesForCount:_intv(request.messageCount)];
		self.messageHeaders = request.messages;
	}
	
	return nil;
}


+ (Mailbox *)loadArchivedWithFilter:(LEMailboxFilterType)filterType {
	return [[[Mailbox alloc] initMailbox:LEMailboxTypeArchived filter:filterType] autorelease];
}


+ (Mailbox *)loadInboxWithFilter:(LEMailboxFilterType)filterType {
	return [[[Mailbox alloc] initMailbox:LEMailboxTypeInbox filter:filterType] autorelease];
}


+ (Mailbox *)loadSentWithFilter:(LEMailboxFilterType)filterType {
	return [[[Mailbox alloc] initMailbox:LEMailboxTypeSent filter:filterType] autorelease];
}


+ (Mailbox *)loadTrashWithFilter:(LEMailboxFilterType)filterType {
	return [[[Mailbox alloc] initMailbox:LEMailboxTypeTrash filter:filterType] autorelease];
}


@end
