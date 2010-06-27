//
//  LEGetBuildings.h
//  DKTest
//
//  Created by Kevin Runde on 3/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBodyGetBuildings : LERequest {
	NSString *bodyId;
	NSMutableDictionary *buildings;
	NSString *surfaceImageName;
}


@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) NSMutableDictionary *buildings;
@property(nonatomic, retain) NSString *surfaceImageName;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target bodyId:(NSString *)bodyId;


@end
