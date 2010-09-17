//
//  Mailbox.h
//  DKTest
//
//  Created by Kevin Runde on 4/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	LEMailboxTypeArchived,
	LEMailboxTypeInbox,
	LEMailboxTypeSent
} LEMailBoxType;


@interface Mailbox : NSObject {
	NSMutableArray *messageHeaders;
	NSMutableDictionary *messageDetails;
	NSInteger pageIndex;
	LEMailBoxType leMailboxType;
	NSInteger originalMessageHeaderCount;
	NSInteger numPages;
}


@property(nonatomic, retain) NSMutableArray *messageHeaders;
@property(nonatomic, retain) NSMutableDictionary *messageDetails;


- (Mailbox *)init:(LEMailBoxType)leMailboxType;
- (BOOL)canArchive;
- (BOOL)hasNextPage;
- (BOOL)hasPreviousPage;
- (void)nextPage;
- (void)previousPage;
- (void)loadMessage:(NSInteger)index;
- (void)archiveMessage:(NSInteger)index;
- (void)loadMessageHeaders;
- (void)loadMessageById:(NSString *)messageId;


+ (Mailbox *)loadArchived;
+ (Mailbox *)loadInbox;
+ (Mailbox *)loadSent;


@end
