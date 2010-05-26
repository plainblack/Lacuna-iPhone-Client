//
//  LEBodyStatus.h
//  UniversalClient
//
//  Created by Kevin Runde on 5/23/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBodyStatus : LERequest {
	NSString *bodyId;
	NSDictionary *body;
}


@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) NSDictionary *body;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target bodyId:(NSString *)bodyId;


@end
