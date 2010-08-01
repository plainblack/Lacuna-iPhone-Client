//
//  TravellingShip.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "TravellingShip.h"
#import "LEMacros.h"
#import "Util.h"


@implementation TravellingShip


@synthesize id;
@synthesize type;
@synthesize dateArrives;
@synthesize fromId;
@synthesize fromType;
@synthesize fromName;
@synthesize toId;
@synthesize toType;
@synthesize toName;


#pragma mark --
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, type:%@, dateArrives:%@, fromId:%@, fromType:%@, fromName:%@, toId:%@, toType:%@, toName:%@", 
			self.id, self.type, self.dateArrives, self.fromId, self.fromType, self.fromName, self.toId, self.toType, self.toName];
}


- (void)dealloc {
	self.id = nil;
	self.type = nil;
	self.dateArrives = nil;
	self.fromId = nil;
	self.fromType = nil;
	self.fromName = nil;
	self.toId = nil;
	self.toType = nil;
	self.toName = nil;
	[super dealloc];
}


#pragma mark --
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)shipData {
	self.id = [shipData objectForKey:@"id"];
	self.type = [shipData objectForKey:@"type"];
	self.dateArrives = [Util date:[shipData objectForKey:@"date_arrives"]];
	NSDictionary *fromData = [shipData objectForKey:@"from"];
	self.fromId = [fromData objectForKey:@"id"];
	self.fromType = [fromData objectForKey:@"type"];
	self.fromName = [fromData objectForKey:@"name"];
	NSDictionary *toData = [shipData objectForKey:@"to"];
	self.toId = [toData objectForKey:@"id"];
	self.toType = [toData objectForKey:@"type"];
	self.toName = [toData objectForKey:@"name"];
}


@end
