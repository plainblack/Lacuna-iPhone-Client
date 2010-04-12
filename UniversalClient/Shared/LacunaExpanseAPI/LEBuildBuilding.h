//
//  LEBuildBuilding.h
//  DKTest
//
//  Created by Kevin Runde on 3/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBuildBuilding : LERequest {
	NSString *bodyId;
	NSNumber *x;
	NSNumber *y;
	NSString *url;
	NSString *buildingId;
}


@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) NSNumber *x;
@property(nonatomic, retain) NSNumber *y;
@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) NSString *buildingId;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target bodyId:(NSString *)bodyId x:(NSNumber *)x y:(NSNumber *)y url:(NSString *)url;


@end
