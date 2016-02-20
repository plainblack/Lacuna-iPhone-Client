//
//  PublicEmpireProfile.m
//  UniversalClient
//
//  Created by Kevin Runde on 9/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "PublicEmpireProfile.h"
#import "LEMacros.h"
#import "Util.h"


@implementation PublicEmpireProfile


@synthesize empireId;
@synthesize name;
@synthesize numPlanets;
@synthesize status;
@synthesize empireDescription;
@synthesize city;
@synthesize country;
@synthesize skype;
@synthesize playerName;
@synthesize lastLogin;
@synthesize founded;
@synthesize speciesName;
@synthesize colonies;
@synthesize medals;
@synthesize allianceId;
@synthesize allianceName;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"empireId:%@, name:%@, numPlanets:%@, status:%@, description:%@, city:%@, country:%@, skype:%@, playerName:%@, lastLogin:%@, founded:%@, speciesName:%@, medalCount:%lu, medalCount:%lu, allianceId:%@, allianceName:%@",
			self.empireId, self.name, self.numPlanets, self.status, self.empireDescription, self.city, self.country, self.skype, self.playerName, self.lastLogin, self.founded, self.speciesName, (unsigned long)[self.colonies count], (unsigned long)[self.medals count], self.allianceId, self.allianceName];
}


- (void)dealloc {
	self.empireId = nil;
	self.name = nil;
	self.numPlanets = nil;
	self.status = nil;
	self.empireDescription = nil;
	self.medals = nil;
	self.city = nil;
	self.country = nil;
	self.skype = nil;
	self.playerName = nil;
	self.lastLogin = nil;
	self.founded = nil;
	self.speciesName = nil;
	self.colonies = nil;
	self.medals = nil;
	self.allianceId = nil;
	self.allianceName = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.empireId = [data objectForKey:@"name"];
	self.name = [data objectForKey:@"name"];
	self.numPlanets = [Util asNumber:[data objectForKey:@"planet_count"]];
	self.status = [data objectForKey:@"status_message"];
	self.empireDescription = [data objectForKey:@"description"];
	self.city = [data objectForKey:@"city"];
	self.country = [data objectForKey:@"country"];
	self.skype = [data objectForKey:@"skype"];
	self.playerName = [data objectForKey:@"player_name"];
	self.lastLogin = [Util date:[data objectForKey:@"last_login"]];
	self.founded = [Util date:[data objectForKey:@"date_founded"]];
	self.speciesName = [data objectForKey:@"species"];
	NSMutableDictionary *allianceData = [data objectForKey:@"alliance"];
	self.allianceId = [Util idFromDict:allianceData named:@"id"];
	self.allianceName = [allianceData objectForKey:@"name"];
	
	self.colonies = [data objectForKey:@"known_colonies"];
	[self.colonies sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease])];

	NSMutableDictionary *medalsDictionary = [data objectForKey:@"medals"];
	NSMutableArray *medalArray = [NSMutableArray arrayWithCapacity:[medalsDictionary count]];
	for (NSString *medalId in medalsDictionary) {
		NSMutableDictionary *medalDictionary = [medalsDictionary objectForKey:medalId];
		[medalDictionary setObject:medalId forKey:@"id"];
		[medalArray addObject:medalDictionary];
	}
	[medalArray sortUsingDescriptors:_array([[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease])];
	self.medals = medalArray;
}


@end
