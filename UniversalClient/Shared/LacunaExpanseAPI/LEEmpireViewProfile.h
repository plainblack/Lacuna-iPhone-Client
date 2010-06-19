//
//  LEEmpireViewProfile.h
//  DKTest
//
//  Created by Kevin Runde on 3/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"

@class Empire;

@interface LEEmpireViewProfile : LERequest {
	NSString *sessionId;
	Empire *empire;
}


@property(nonatomic, retain) NSString *sessionId;
@property(nonatomic, retain) Empire *empire;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target sessionId:(NSString *)sessionId;


@end
