//
//  LEGetSystem.h
//  DKTest
//
//  Created by Kevin Runde on 2/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEGetSystem : LERequest {
	NSString *systemId;
	NSDictionary *star;
	NSArray *bodies;
}


@property(nonatomic, retain) NSString *systemId;
@property(nonatomic, retain) NSDictionary *star;
@property(nonatomic, retain) NSArray *bodies;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target systemId:(NSString *)systemId;


@end
