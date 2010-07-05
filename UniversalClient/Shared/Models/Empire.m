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
@synthesize profile;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, isIsolationist:%i, name:%@, statusMessage:%@, homePlanetId:%@, essentia:%i, numNewMessages:%i, planets:%@", 
			self.id, self.isIsolationist, self.name, self.statusMessage, self.homePlanetId, self.essentia, self.numNewMessages, self.planets];
}


- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.statusMessage = nil;
	self.homePlanetId = nil;
	self.lastMessageAt = nil;
	self.planets = nil;
	self.profile = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark NSObject Methods

- (void)loadProfile {
	NSLog(@"NEED TO IMPLEMENT");
}


- (void)parseData:(NSDictionary *)empireData {
	self.id = [empireData objectForKey:@"id"];
	self.isIsolationist = _intv([empireData objectForKey:@"is_isolationist"]);
	self.name = [empireData objectForKey:@"name"];
	self.statusMessage = [empireData objectForKey:@"status_message"];
	self.homePlanetId = [empireData objectForKey:@"home_planet_id"];
	self.essentia = _intv([empireData objectForKey:@"essentia"]);
	self.numNewMessages = _intv([empireData objectForKey:@"has_new_messages"]);
	self.planets = [empireData objectForKey:@"planets"];
	
	NSDictionary *newestMessage = [empireData objectForKey:@"most_recent_message"];
	if (newestMessage && (id)newestMessage != [NSNull null]) {
		NSString *dateReceivedString = [newestMessage objectForKey:@"date_received"];
		if (dateReceivedString) {
			self.lastMessageAt = [Util date:dateReceivedString];
		}
	}
	
}


@end
