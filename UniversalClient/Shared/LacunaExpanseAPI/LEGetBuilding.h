//
//  LEGetBuilding.h
//  DKTest
//
//  Created by Kevin Runde on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEGetBuilding : LERequest {
	NSString *buildingId;
	NSMutableDictionary *building;
	NSString *url;
}


@property(nonatomic, retain) NSString *buildingId;
@property(nonatomic, retain) NSMutableDictionary *building;
@property(nonatomic, retain) NSString *url;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target buildingId:(NSString *)buildingId url:(NSString *)url;


@end
