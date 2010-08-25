//
//  MyAllianceInvite.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/24/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyAllianceInvite : NSObject {
	NSString *id;
	NSString *name;
	NSString *allianceId;
}


@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *allianceId;


- (void)parseData:(NSDictionary *)data;


@end
