//
//  LEBuildingAddToSpyMarket.m
//  UniversalClient
//
//  Created by Kevin Runde on 3/26/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import "LEBuildingAddToSpyMarket.h"
#import "LEMacros.h"
#import "Session.h"


@implementation LEBuildingAddToSpyMarket


- (id)params {
	NSMutableArray *params = _array([Session sharedInstance].sessionId, self.buildingId);
    
    [params addObject:[[self.offer objectAtIndex:0] objectForKey:@"spy_id"]];
    [params addObject:self.askEssentia];
	
	if (self.tradeShipId) {
		[params addObject:_dict(self.tradeShipId, @"ship_id", [NSNumber numberWithInt:1], @"stay")];
	}
    
    NSLog(@"Add to Spy Market Params: %@", params);
	return params;
}


@end
