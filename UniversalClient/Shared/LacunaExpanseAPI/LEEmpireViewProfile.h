//
//  LEEmpireViewProfile.h
//  DKTest
//
//  Created by Kevin Runde on 3/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireViewProfile : LERequest {
	NSString *sessionId;
	NSString *description;
	NSString *status;
	NSArray *medals;
}


@property(nonatomic, retain) NSString *sessionId;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *status;
@property(nonatomic, retain) NSArray *medals;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target sessionId:(NSString *)sessionId;


@end
