//
//  TravellingShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TravellingShip : NSObject {
	NSString *id;
	NSString *type;
	NSDate *dateArrives;
	NSString *fromId;
	NSString *fromType;
	NSString *fromName;
	NSString *toId;
	NSString *toType;
	NSString *toName;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSDate *dateArrives;
@property (nonatomic, retain) NSString *fromId;
@property (nonatomic, retain) NSString *fromType;
@property (nonatomic, retain) NSString *fromName;
@property (nonatomic, retain) NSString *toId;
@property (nonatomic, retain) NSString *toType;
@property (nonatomic, retain) NSString *toName;


- (void)parseData:(NSDictionary *)spyData;


@end
