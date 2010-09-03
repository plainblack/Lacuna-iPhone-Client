//
//  LEEmpireSendPasswordResetMessage.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireSendPasswordResetMessage : LERequest {
	NSString *empireId;
	NSString *empireName;
	NSString *emailAddress;
}


@property(nonatomic, retain) NSString *empireId;
@property(nonatomic, retain) NSString *empireName;
@property(nonatomic, retain) NSString *emailAddress;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target empireId:(NSString *)empireId empireName:(NSString *)empireName emailAddress:(NSString *)emailAddress;


@end
