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
	NSString *forumUri;
	NSString *description;
	NSString *announcements;
	NSDate *dateCreated;
	NSMutableArray *members;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *leaderId;
@property (nonatomic, retain) NSString *forumUri;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *announcements;
@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, retain) NSMutableArray *members;


- (void)parseData:(NSDictionary *)data;


@end
