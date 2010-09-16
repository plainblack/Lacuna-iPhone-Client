//
//  LEEmpireViewPublicProfile.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/15/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireViewPublicProfile : LERequest {
	NSString *sessionId;
	NSString *empireId;
	NSDictionary *profile;
}


@property(nonatomic, retain) NSString *sessionId;
@property(nonatomic, retain) NSString *empireId;
@property(nonatomic, retain) NSDictionary *profile;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target sessionId:(NSString *)sessionId empireId:(NSString *)empireId;


@end
