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
@property (nonatomic, assign) NSString *fromId;
@property (nonatomic, assign) NSString *fromType;
@property (nonatomic, assign) NSString *fromName;
@property (nonatomic, assign) NSString *toId;
@property (nonatomic, assign) NSString *toType;
@property (nonatomic, assign) NSString *toName;


- (void)parseData:(NSDictionary *)spyData;


@end
