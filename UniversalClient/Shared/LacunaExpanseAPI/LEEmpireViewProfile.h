//
//  LEEmpireViewProfile.h
//  DKTest
//
//  Created by Kevin Runde on 3/30/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"

@class EmpireProfile;

@interface LEEmpireViewProfile : LERequest {
	NSString *sessionId;
	EmpireProfile *empire;
}


@property(nonatomic, retain) NSString *sessionId;
@property(nonatomic, retain) EmpireProfile *empire;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target sessionId:(NSString *)sessionId;


@end
