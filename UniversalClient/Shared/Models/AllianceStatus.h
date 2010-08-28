//
//  AllianceStatus.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllianceStatus : NSObject {
	NSString *id;
	NSString *name;
	NSString *leaderId;
	NSString *leaderName;
	NSString *forumUri;
	NSString *allianceDescription;
	NSString *announcements;
	NSDate *dateCreated;
	NSMutableArray *members;
	NSDate *dateLoaded;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *leaderId;
@property (nonatomic, retain) NSString *leaderName;
@property (nonatomic, retain) NSString *forumUri;
@property (nonatomic, retain) NSString *allianceDescription;
@property (nonatomic, retain) NSString *announcements;
@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, retain) NSMutableArray *members;
@property (nonatomic, retain) NSDate *dateLoaded;


- (void)parseData:(NSDictionary *)data;


@end
