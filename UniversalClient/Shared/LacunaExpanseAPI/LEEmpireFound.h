//
//  LEEmpireFound.h
//  DKTest
//
//  Created by Kevin Runde on 3/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireFound : LERequest {
	NSString *empireId;
	NSString *sessionId;
	NSString *inviteCode;
	NSDictionary *empireData;
}


@property(nonatomic, retain) NSString *empireId;
@property(nonatomic, retain) NSString *sessionId;
@property(nonatomic, retain) NSString *inviteCode;
@property(nonatomic, retain) NSDictionary *empireData;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target empireId:(NSString *)empireId inviteCode:(NSString *)inviteCode;


@end
