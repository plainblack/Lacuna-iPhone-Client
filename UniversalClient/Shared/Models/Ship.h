//
//  Ship.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Ship : NSObject {
}

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *typeHumanized;
@property (nonatomic, retain) NSString *task;
@property (nonatomic, retain) NSDecimalNumber *speed;
@property (nonatomic, retain) NSDecimalNumber *fleetSpeed;
@property (nonatomic, retain) NSDecimalNumber *stealth;
@property (nonatomic, retain) NSDecimalNumber *holdSize;
@property (nonatomic, retain) NSDecimalNumber *berthLevel;
@property (nonatomic, retain) NSDecimalNumber *combat;
@property (nonatomic, retain) NSDecimalNumber *maxOccupants;
@property (nonatomic, retain) NSMutableArray *payload;
@property (nonatomic, retain) NSDate *dateStarted;
@property (nonatomic, retain) NSDate *dateAvailable;
@property (nonatomic, retain) NSDate *dateArrives;
@property (nonatomic, retain) NSString *fromId;
@property (nonatomic, retain) NSString *fromType;
@property (nonatomic, retain) NSString *fromName;
@property (nonatomic, retain) NSString *fromEmpireId;
@property (nonatomic, retain) NSString *fromEmpireName;
@property (nonatomic, retain) NSString *toId;
@property (nonatomic, retain) NSString *toType;
@property (nonatomic, retain) NSString *toName;
@property (nonatomic, retain) NSString *orbitingId;
@property (nonatomic, retain) NSString *orbitingName;
@property (nonatomic, retain) NSString *orbitingType;
@property (nonatomic, retain) NSDecimalNumber *orbitingX;
@property (nonatomic, retain) NSDecimalNumber *orbitingY;


- (void)parseData:(NSDictionary *)shipData;
- (NSString *)prettyPayload;


@end
