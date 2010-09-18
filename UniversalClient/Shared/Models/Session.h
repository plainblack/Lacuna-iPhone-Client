//
//  Session.h
//  DKTest
//
//  Created by Kevin Runde on 1/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Empire.h"
#import "Body.h"


@interface Session : NSObject {
	NSString *sessionId;
	Empire *empire;
	Body *body;
	BOOL isLoggedIn;
	NSMutableArray *savedEmpireList;
	NSString *serverVersion;
	NSTimer *timer;
	NSDate *lastTick;
	id reloginTarget;
	SEL reloginSelector;
	NSString *serverUri;
	NSDictionary *itemDescriptions;
}


@property (nonatomic, retain) NSString *sessionId;
@property (nonatomic, retain) Empire *empire;
@property (nonatomic, retain) Body *body;
@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, retain) NSMutableArray *savedEmpireList;
@property (nonatomic, retain) NSString *serverVersion;
@property (nonatomic, retain) NSDate *lastTick;
@property (nonatomic, retain) NSString *serverUri;
@property (nonatomic, retain) NSDictionary *itemDescriptions;


- (void)loginWithUsername:(NSString *)username password:(NSString *)password;
- (void)logout;
- (void)reloginTarget:(id)target selector:(SEL)selector;
- (void)forgetEmpireNamed:(NSString *)empireName;
- (void)processStatus:(NSDictionary *)status;
- (void)loadBody:(NSString *)bodyId;
- (void)loggedInEmpireData:(NSDictionary *)empireData sessionId:(NSString *)sessionId password:(NSString *)password;
- (void)saveToKeyChainForUsername:(NSString *)username password:(NSString *)password;
- (void)readItemDescriptions;
- (NSString *)descriptionForBuilding:(NSString *)buildingUrl;
- (NSString *)wikiLinkForBuilding:(NSString *)buildingUrl;
- (NSString *)descriptionForShip:(NSString *)shipType;
- (NSString *)wikiLinkForShip:(NSString *)shipType;


+ (Session *)sharedInstance;


@end
