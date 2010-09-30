//
//  LEBuildingPrepareFetchSpies.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildingPrepareFetchSpies : LERequest {
	NSString *onBodyId;
	NSString *toBodyId;
	NSMutableArray *ships;
	NSMutableArray *spies;
}


@property(nonatomic, retain) NSString *onBodyId;
@property(nonatomic, retain) NSString *toBodyId;
@property(nonatomic, retain) NSMutableArray *ships;
@property(nonatomic, retain) NSMutableArray *spies;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target onBodyId:(NSString *)onBodyId toBodyId:(NSString *)toBodyId;


@end
