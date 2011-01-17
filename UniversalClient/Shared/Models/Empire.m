//
//  Empire.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Empire.h"
#import "EmpireProfile.h"
#import "LEMacros.h"
#import "Util.h"
#import "LEEmpireChangePassword.h"
#import "LEEmpireEnableSelfDestruct.h"
#import "LEEmpireDisableSelfDestruct.h"
#import "LEEmpireInviteFriend.h"
#import "LEEmpireRedeemEssentiaCode.h"


@implementation Empire


@synthesize id;
@synthesize isIsolationist;
@synthesize name;
@synthesize statusMessage;
@synthesize homePlanetId;
@synthesize lastMessageAt;
@synthesize numNewMessages;
@synthesize essentia;
@synthesize planets;
@synthesize selfDestructActive;
@synthesize selfDestructAt;
@synthesize profile;
@synthesize rpcCount;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, isIsolationist:%i, name:%@, statusMessage:%@, homePlanetId:%@, essentia:%@, numNewMessages:%@, planets:%@, selfDestructActive:%i, selfDestructAt:%@", 
			self.id, self.isIsolationist, self.name, self.statusMessage, self.homePlanetId, self.essentia, self.numNewMessages, self.planets, self.selfDestructActive, self.selfDestructAt];
}


- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.statusMessage = nil;
	self.homePlanetId = nil;
	self.lastMessageAt = nil;
	self.numNewMessages = nil;
	self.essentia = nil;
	self.planets = nil;
	self.selfDestructAt = nil;
	self.profile = nil;
	self.rpcCount = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)loadProfile {
	NSLog(@"NEED TO IMPLEMENT");
}


- (void)parseData:(NSDictionary *)empireData {
	self.id = [Util idFromDict:empireData named:@"id"];
	self.isIsolationist = _boolv([empireData objectForKey:@"is_isolationist"]);
	NSString *tmpName = [empireData objectForKey:@"name"];
	if (isNotNull(tmpName) && [tmpName length] > 0) {
		self.name = tmpName;
	}
	self.statusMessage = [empireData objectForKey:@"status_message"];
	self.homePlanetId = [empireData objectForKey:@"home_planet_id"];
	self.essentia = [Util asNumber:[empireData objectForKey:@"essentia"]];
	self.numNewMessages = [Util asNumber:[empireData objectForKey:@"has_new_messages"]];
	self.selfDestructActive = _boolv([empireData objectForKey:@"self_destruct_active"]);
	self.selfDestructAt = [Util date:[empireData objectForKey:@"self_destruct_date"]];

	NSDictionary *planetsData = [empireData objectForKey:@"planets"];
	NSMutableArray *tmpPlanets = [NSMutableArray arrayWithCapacity:[planetsData count]];
	[planetsData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		[tmpPlanets addObject:_dict([Util asString:key], @"id", obj, @"name")];
	}];
	self.planets = tmpPlanets;
	
	NSDictionary *newestMessage = [empireData objectForKey:@"most_recent_message"];
	if (isNotNull(newestMessage)) {
		NSString *dateReceivedString = [newestMessage objectForKey:@"date_received"];
		if (dateReceivedString) {
			self.lastMessageAt = [Util date:dateReceivedString];
		}
	}
	
	self.rpcCount = [Util asNumber:[empireData objectForKey:@"rpc_count"]];
}


- (void)changeToPassword:(NSString *)newPassword confirmPassword:(NSString *)newPasswordConfirm target:(id)target callback:(SEL)callback{
	self->changePasswordTarget = target;
	self->changePasswordCallback = callback;
	[[[LEEmpireChangePassword alloc] initWithCallback:@selector(passwordChanged:) target:self newPassword:newPassword newPasswordConfirm:newPasswordConfirm] autorelease];
}


- (void)setSelfDestruct:(BOOL)enabled {
	if (enabled) {
		[[[LEEmpireEnableSelfDestruct alloc] initWithCallback:@selector(selfDestructEnabled:) target:self] autorelease];
	} else {
		[[[LEEmpireDisableSelfDestruct alloc] initWithCallback:@selector(selfDestructDisabled:) target:self] autorelease];
	}
}


- (void)sendInviteTo:(NSString *)emailAddress {
	[[[LEEmpireInviteFriend alloc] initWithCallback:@selector(inviteSent:) target:self email:emailAddress] autorelease];
}


- (void)redeemEssentiaCode:(NSString *)code {
	[[[LEEmpireRedeemEssentiaCode alloc] initWithCallback:@selector(essentiaCodeRedeemed:) target:self code:code] autorelease];
}


#pragma mark -
#pragma mark Callback Methods

- (id)passwordChanged:(LEEmpireChangePassword *)request {
	[self->changePasswordTarget performSelector:self->changePasswordCallback withObject:request];
	return nil;
}


- (id)selfDestructDisabled:(LEEmpireDisableSelfDestruct *)request {
	return nil;
}


- (id)selfDestructEnabled:(LEEmpireEnableSelfDestruct *)request {
	return nil;
}


- (id)inviteSent:(LEEmpireInviteFriend *)request {
	return nil;
}


- (id)essentiaCodeRedeemed:(LEEmpireRedeemEssentiaCode *)request {
	return nil;
}


@end
