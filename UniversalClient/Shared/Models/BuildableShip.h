//
//  BuildableShip.h
//  UniversalClient
//
//  Created by Kevin Runde on 7/31/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceCost.h"


@interface BuildableShip : NSObject {
	NSString *type;
	BOOL canBuild;
	NSMutableArray *reason;
	ResourceCost *buildCost;
	NSMutableDictionary *attributes;
}


@property (nonatomic, retain) NSString *type;
@property (nonatomic, assign) BOOL canBuild;
@property (nonatomic, retain) NSMutableArray *reason;
@property (nonatomic, retain) ResourceCost *buildCost;
@property (nonatomic, retain) NSMutableDictionary *attributes;


- (void)parseData:(NSDictionary *)buildableShipData;


@end
