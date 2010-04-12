//
//  Session.h
//  DKTest
//
//  Created by Kevin Runde on 1/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Session : NSObject {
	NSString *sessionId;
	NSDictionary *empireData;
	BOOL isLoggedIn;
	NSNumber *mapCenterX;
	NSNumber *mapCenterY;
	NSNumber *mapCenterZ;
	NSNumber *numNewMessages;
	NSMutableArray *empireList;
}

@property(nonatomic, retain) NSString *sessionId;
@property(nonatomic, retain) NSDictionary *empireData;
@property(nonatomic) BOOL isLoggedIn;
@property(nonatomic, retain) NSNumber *mapCenterX;
@property(nonatomic, retain) NSNumber *mapCenterY;
@property(nonatomic, retain) NSNumber *mapCenterZ;
@property(nonatomic, retain) NSNumber *numNewMessages;
@property(nonatomic, retain) NSMutableArray *empireList;


+ (Session *)sharedInstance;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)logout;
- (void)updateStatus;
- (void)forgetEmpireNamed:(NSString *)empireName;


@end
