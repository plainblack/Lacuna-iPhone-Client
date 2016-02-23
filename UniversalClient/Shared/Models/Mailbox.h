//
//  Mailbox.h
//  DKTest
//
//  Created by Kevin Runde on 4/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    LEMailboxTypeNone,
	LEMailboxTypeArchived,
	LEMailboxTypeInbox,
	LEMailboxTypeSent,
	LEMailboxTypeTrash,
} LEMailboxType;


typedef enum {
    LEMailboxFilterTypeNone,
    LEMailboxFilterTypeAlert,
    LEMailboxFilterTypeAttack,
    LEMailboxFilterTypeColonization,
    LEMailboxFilterTypeComplaint,
    LEMailboxFilterTypeCorrespondence,
    LEMailboxFilterTypeExcavator,
	LEMailboxFilterTypeFissure,
    LEMailboxFilterTypeIntelligence,
    LEMailboxFilterTypeMedal,
    LEMailboxFilterTypeMission,
    LEMailboxFilterTypeParliament,
    LEMailboxFilterTypeProbe,
    LEMailboxFilterTypeSpies,
    LEMailboxFilterTypeTrade,    
    LEMailboxFilterTypeTutorial,
} LEMailboxFilterType;


@interface Mailbox : NSObject {
	NSInteger pageIndex;
	LEMailboxType leMailboxType;
	LEMailboxFilterType leMailboxFilterType;
	NSInteger originalMessageHeaderCount;
	NSInteger numPages;
}


@property(nonatomic, retain) NSMutableArray *messageHeaders;
@property(nonatomic, retain) NSMutableDictionary *messageDetails;


- (Mailbox *)initMailbox:(LEMailboxType)leMailboxType filter:(LEMailboxFilterType)leMailboxFilterType;
- (BOOL)canArchive;
- (BOOL)canTrash;
- (BOOL)hasNextPage;
- (BOOL)hasPreviousPage;
- (void)nextPage;
- (void)previousPage;
- (void)loadMessage:(NSInteger)index;
- (void)archiveMessage:(NSInteger)index;
- (void)archiveMessages:(NSSet *)messageIds;
- (void)trashMessage:(NSInteger)index;
- (void)trashMessages:(NSSet *)messageIds;
- (void)loadMessageHeaders;
- (void)loadMessageById:(NSString *)messageId;
- (NSArray *)filterTags;


+ (Mailbox *)loadArchivedWithFilter:(LEMailboxFilterType)filterType;
+ (Mailbox *)loadInboxWithFilter:(LEMailboxFilterType)filterType;
+ (Mailbox *)loadSentWithFilter:(LEMailboxFilterType)filterType;
+ (Mailbox *)loadTrashWithFilter:(LEMailboxFilterType)filterType;


@end
