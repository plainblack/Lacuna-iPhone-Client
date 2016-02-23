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
@synthesize fleetSpeed;
@synthesize holdSize;
@synthesize berthLevel;
@synthesize stealth;
@synthesize combat;
@synthesize	maxOccupants;
@synthesize payload;
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
@synthesize orbitingId;
@synthesize orbitingType;
@synthesize orbitingName;
@synthesize orbitingX;
@synthesize orbitingY;


#pragma mark -
#pragma mark NSObject Methods

- (NSString *)description {
	return [NSString stringWithFormat:@"id:%@, name:%@, type:%@, typeHumanized:%@, task:%@, speed:%@, fleetSpeed:%@, holdSize:%@, berthLevel:%@, stealth:%@, combat: %@, maxOccupants:%@, dateStarted:%@, dateAvailable:%@, dateArrives:%@, fromId:%@, fromType:%@, fromName:%@, fromEmpireId:%@ fromEmpireName:%@, toId:%@, toType:%@, toName:%@, payload:%@, obitingId:%@, obitingType:%@, obitingName:%@, orbitingX:%@, orbitingY:%@",
			self.id, self.name, self.type, self.typeHumanized, self.task, self.speed, self.fleetSpeed, self.holdSize, self.berthLevel, self.stealth, self.combat, self.maxOccupants, self.dateStarted, self.dateAvailable, self.dateArrives, self.fromId, self.fromType, self.fromName, self.fromEmpireId, self.fromEmpireName, self.toId, self.toType, self.toName, self.payload, self.orbitingId, self.orbitingType, self.orbitingName, self.orbitingX, self.orbitingY];
}


- (void)dealloc {
	self.id = nil;
	self.name = nil;
	self.type = nil;
	self.typeHumanized = nil;
	self.task = nil;
	self.speed = nil;
    self.fleetSpeed = nil;
	self.holdSize = nil;
    self.berthLevel = nil;
	self.stealth = nil;
	self.combat = nil;
	self.maxOccupants = nil;
	self.payload = nil;
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
	self.orbitingId = nil;
	self.orbitingType = nil;
	self.orbitingName = nil;
	self.orbitingX = nil;
	self.orbitingY = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark Instance Methods

- (void)parseData:(NSDictionary *)shipData {
    NSLog(@"Ship Data: %@", shipData);
	self.id = [Util idFromDict:shipData named:@"id"];
	self.name = [shipData objectForKey:@"name"];
	self.type = [shipData objectForKey:@"type"];
	self.typeHumanized = [shipData objectForKey:@"type_human"];
	self.task = [shipData objectForKey:@"task"];
	self.speed = [Util asNumber:[shipData objectForKey:@"speed"]];
	self.fleetSpeed = [Util asNumber:[shipData objectForKey:@"fleet_speed"]];
	self.holdSize = [Util asNumber:[shipData objectForKey:@"hold_size"]];
    self.berthLevel = [Util asNumber:[shipData objectForKey:@"berth_level"]];
	self.stealth = [Util asNumber:[shipData objectForKey:@"stealth"]];
	self.combat = [Util asNumber:[shipData objectForKey:@"combat"]];
	self.maxOccupants = [Util asNumber:[shipData objectForKey:@"max_occupants"]];
	self.stealth = [Util asNumber:[shipData objectForKey:@"stealth"]];
	self.payload = [shipData objectForKey:@"payload"];
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
	NSDictionary *orbitingData = [shipData objectForKey:@"orbiting"];
	self.orbitingId = [Util idFromDict:orbitingData named:@"id"];
	self.orbitingType = [orbitingData objectForKey:@"type"];
	self.orbitingName = [orbitingData objectForKey:@"name"];
	self.orbitingX = [Util asNumber:[orbitingData objectForKey:@"x"]];
	self.orbitingY = [Util asNumber:[orbitingData objectForKey:@"y"]];
}


- (NSString *)prettyPayload {
	if (isNotNull(self.payload)) {
		if ([self.payload count]>0) {
			return [self.payload componentsJoinedByString:@"; "];
		} else {
			return @"Empty";
		}
	} else {
		return @"Unknown";
	}	
}



@end
