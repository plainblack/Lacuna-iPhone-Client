//
//  Empire.h
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmpireProfile.h"


@class EmpireProfile;


@interface Empire : NSObject {
	NSString *id;
	BOOL isIsolationist;
	NSString *name;
	NSString *statusMessage;
	NSString *homePlanetId;
	NSDate *lastMessageAt;
	NSInteger numNewMessages;
	NSInteger essentia;
	NSDictionary *planets;
	EmpireProfile *profile;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, assign) BOOL isIsolationist;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *statusMessage;
@property (nonatomic, retain) NSString *homePlanetId;
@property(nonatomic, retain) NSDate *lastMessageAt;
@property (nonatomic, assign) NSInteger numNewMessages;
@property (nonatomic, assign) NSInteger essentia;
@property (nonatomic, retain) NSDictionary *planets;
@property (nonatomic, retain) EmpireProfile *profile;


- (void)loadProfile;
- (void)parseData:(NSDictionary *)empireData;


@end
