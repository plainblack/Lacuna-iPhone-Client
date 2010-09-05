//
//  Empire.m
//  UniversalClient
//
//  Created by Kevin Runde on 6/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "EmpireProfile.h"
#import "LEMacros.h"


@implementation EmpireProfile


@synthesize empireDescription;
@synthesize status;
@synthesize medals;
@synthesize city;
@synthesize country;
@synthesize skype;
@synthesize playerName;
@synthesize email;
@synthesize sitterPassword;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"description:%@, status:%@, city:%@, country:%@, skype:%@, playerName:%@, email:%@, sitterPassword:%@, medalCount:%i",
			self.empireDescription, self.status, self.city, self.country, self.skype, self.playerName, self.email, self.sitterPassword, [self.medals count]];
}


- (void)dealloc {
	self.empireDescription = nil;
	self.status = nil;
	self.medals = nil;
	self.city;
	self.country;
	self.skype;
	self.playerName;
	self.email;
	self.sitterPassword;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)data {
	self.empireDescription = [data objectForKey:@"description"];
	self.status = [data objectForKey:@"status_message"];
	self.city = [data objectForKey:@"city"];
	self.country = [data objectForKey:@"country"];
	self.skype = [data objectForKey:@"skype"];
	self.playerName = [data objectForKey:@"player_name"];
	self.email = [data objectForKey:@"email"];
	self.sitterPassword = [data objectForKey:@"sitter_password"];

	NSMutableDictionary *medalsDictionary = [data objectForKey:@"medals"];
	NSMutableArray *medalArray = [NSMutableArray arrayWithCapacity:[medalsDictionary count]];
	for (NSString *medalId in medalsDictionary) {
		NSMutableDictionary *medalDictionary = [medalsDictionary objectForKey:medalId];
		[medalDictionary setObject:medalId forKey:@"id"];
		[medalArray addObject:medalDictionary];
	}
	[medalArray sortUsingDescriptors:_array([[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES])];
	self.medals = medalArray;
}


@end
