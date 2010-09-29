//
//  Ship.m
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import "Ship.h"
#import "LEMacros.h"
#import "Util.h"


@implementation Ship


@synthesize id;
@synthesize name;
@synthesize type;
@synthesize typeHumanized;
@synthesize task;
@synthesize speed;
@synthesize holdSize;
@synthesize stealth;
@synthesize dateStarted;
@synthesize dateAvailable;
@synthesize dateArrives;
@synthesize fromId;
@synthesize fromType;
@synthesize fromName;
@synthesize fromEmpireId;
@synthesize fromEmpireName;
@synthesize toId;
@synthesize toType;
@synthesize toName;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, type:%@, typeHumanized:%@, task:%@, speed:%@, holdSize:%@, stealth:%@, dateStarted:%@, dateAvailable:%@, dateArrives:%@, fromId:%@, fromType:%@, fromName:%@, fromEmpireId:%@ fromEmpireName:%@, toId:%@, toType:%@, toName:%@", 
			self.id, self.name, self.type, self.typeHumanized, self.task, self.speed, self.holdSize, self.stealth, self.dateStarted, self.dateAvailable, self.dateArrives, self.fromId, self.fromType, self.fromName, self.fromEmpireId, self.fromEmpireName, self.toId, self.toType, self.toName];
}


- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.type = nil;
	self.typeHumanized = nil;
	self.task = nil;
	self.speed = nil;
	self.holdSize = nil;
	self.stealth = nil;
	self.dateStarted = nil;
	self.dateAvailable = nil;
	self.dateArrives = nil;
	self.fromId = nil;
	self.fromType = nil;
	self.fromName = nil;
	self.fromEmpireId = nil;
	self.fromEmpireName = nil;
	self.toId = nil;
	self.toType = nil;
	self.toName = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)shipData {
	self.id = [Util idFromDict:shipData named:@"id"];
	self.name = [shipData objectForKey:@"name"];
	self.type = [shipData objectForKey:@"type"];
	self.typeHumanized = [shipData objectForKey:@"type_human"];
	self.task = [shipData objectForKey:@"task"];
	self.speed = [Util asNumber:[shipData objectForKey:@"speed"]];
	self.holdSize = [Util asNumber:[shipData objectForKey:@"hold_size"]];
	self.stealth = [Util asNumber:[shipData objectForKey:@"stealth"]];
	self.dateStarted = [Util date:[shipData objectForKey:@"date_started"]];
	self.dateAvailable = [Util date:[shipData objectForKey:@"date_available"]];
	self.dateArrives = [Util date:[shipData objectForKey:@"date_arrives"]];
	NSDictionary *fromData = [shipData objectForKey:@"from"];
	self.fromId = [Util idFromDict:fromData named:@"id"];
	self.fromType = [fromData objectForKey:@"type"];
	self.fromName = [fromData objectForKey:@"name"];
	NSDictionary *fromEmpireData = [fromData objectForKey:@"empire"];
	self.fromEmpireId = [fromEmpireData objectForKey:@"id"];
	self.fromEmpireName = [fromEmpireData objectForKey:@"name"];
	NSDictionary *toData = [shipData objectForKey:@"to"];
	self.toId = [Util idFromDict:toData named:@"id"];
	self.toType = [toData objectForKey:@"type"];
	self.toName = [toData objectForKey:@"name"];
}


@end
