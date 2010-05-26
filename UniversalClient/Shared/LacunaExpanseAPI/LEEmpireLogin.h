//
//  LEEmpireLogin.h
//  DKTest
//
//  Created by Kevin Runde on 3/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireLogin : LERequest {
	NSString *username;
	NSString *password;
	NSString *sessionId;
	NSDictionary *empireData;
}


@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSString *sessionId;
@property(nonatomic, retain) NSDictionary *empireData;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target username:(NSString *)username password:(NSString *)password;


@end
