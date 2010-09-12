//
//  Ship.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Ship : NSObject {
	NSString *id;
	NSString *name;
	NSString *type;
	NSString *typeHumanized;
	NSString *task;
	NSDecimalNumber *speed;
	NSDecimalNumber *holdSize;
	NSDecimalNumber *stealth;
	NSDate *dateStarted;
	NSDate *dateAvailable;
	NSDate *dateArrives;
	NSString *fromId;
	NSString *fromType;
	NSString *fromName;
	NSString *fromEmpireId;
	NSString *fromEmpireName;
	NSString *toId;
	NSString *toType;
	NSString *toName;
}

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *typeHumanized;
@property (nonatomic, retain) NSString *task;
@property (nonatomic, retain) NSDecimalNumber *speed;
@property (nonatomic, retain) NSDecimalNumber *holdSize;
@property (nonatomic, retain) NSDecimalNumber *stealth;
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


- (void)parseData:(NSDictionary *)shipData;


@end
