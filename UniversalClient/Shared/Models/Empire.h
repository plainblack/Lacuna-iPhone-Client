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
	id changePasswordTarget;
	SEL changePasswordCallback;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, assign) BOOL isIsolationist;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *statusMessage;
@property (nonatomic, retain) NSString *homePlanetId;
@property (nonatomic, retain) NSDate *lastMessageAt;
@property (nonatomic, retain) NSDecimalNumber *numNewMessages;
@property (nonatomic, retain) NSDecimalNumber *essentia;
@property (nonatomic, retain) NSMutableArray *planets;
@property (nonatomic, assign) BOOL selfDestructActive;
@property (nonatomic, retain) NSDate *selfDestructAt;
@property (nonatomic, retain) EmpireProfile *profile;
@property (nonatomic, retain) NSDecimalNumber *rpcCount;


- (void)loadProfile;
- (void)parseData:(NSDictionary *)empireData;
- (void)changeToPassword:(NSString *)newPassword confirmPassword:(NSString *)newPasswordConfirm target:(id)target callback:(SEL)callback;
- (void)setSelfDestruct:(BOOL)enabled;
- (void)sendInviteTo:(NSString *)emailAddress;
- (void)redeemEssentiaCode:(NSString *)code;


@end
