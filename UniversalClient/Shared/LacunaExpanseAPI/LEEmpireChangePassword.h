//
//  LEEmpireChangePassword.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireChangePassword : LERequest {
	NSString *currentPassword;
	NSString *newPassword;
	NSString *newPasswordConfirm;
}


@property (nonatomic, retain) NSString *currentPassword;
@property (nonatomic, retain) NSString *newPassword;
@property (nonatomic, retain) NSString *newPasswordConfirm;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target currentPassword:(NSString *)currentPassword newPassword:(NSString *)newPassword newPasswordConfirm:(NSString *)newPasswordConfirm;


@end
