//
//  Session.h
//  DKTest
//
//  Created by Kevin Runde on 1/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Empire.h"


@interface Session : NSObject {
	NSString *sessionId;
	Empire *empire;
	BOOL isLoggedIn;
	NSNumber *mapCenterX;
	NSNumber *mapCenterY;
	NSNumber *mapCenterZ;
	NSInteger numNewMessages;
	NSMutableArray *empireList;
	NSDate *lastMessageAt;
	NSString *serverVersion;
}

@property(nonatomic, retain) NSString *sessionId;
@property(nonatomic, retain) Empire *empire;
@property(nonatomic, assign) BOOL isLoggedIn;
@property(nonatomic, retain) NSNumber *mapCenterX;
@property(nonatomic, retain) NSNumber *mapCenterY;
@property(nonatomic, retain) NSNumber *mapCenterZ;
@property(nonatomic, assign) NSInteger numNewMessages;
@property(nonatomic, retain) NSMutableArray *empireList;
@property(nonatomic, retain) NSDate *lastMessageAt;
@property(nonatomic, retain) NSString *serverVersion;


- (void)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)logout;
- (void)forgetEmpireNamed:(NSString *)empireName;
- (void)processStatus:(NSDictionary *)status;

+ (Session *)sharedInstance;


@end
