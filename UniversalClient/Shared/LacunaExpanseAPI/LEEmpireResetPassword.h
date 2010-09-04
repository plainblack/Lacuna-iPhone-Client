//
//  LEEmpireResetPassword.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/2/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireResetPassword : LERequest {
	NSString *resetKey;
	NSString *password;
	NSString *passwordConfirmation;
	NSString *sessionId;
	NSDictionary *empireData;
}


@property(nonatomic, retain) NSString *resetKey;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSString *passwordConfirmation;
@property(nonatomic, retain) NSString *sessionId;
@property(nonatomic, retain) NSDictionary *empireData;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target resetKey:(NSString *)resetKey password:(NSString *)password passwordConfirmation:(NSString *)passwordConfirmation;


@end
