//
//  AlliancePublicProfile.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlliancePublicProfile : NSObject {

}


@property (retain) NSString *id;
@property (retain) NSString *name;
@property (retain) NSString *publicDescription;
@property (retain) NSString *leaderId;
@property (retain) NSString *leaderName;
@property (retain) NSDate *dateCreated;
@property (retain) NSDecimalNumber *influence;
@property (retain) NSMutableArray *members;
@property (retain) NSMutableArray *spaceStations;


- (void)parseData:(NSMutableDictionary *)data;


@end
