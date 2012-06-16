//
//  LEEmpireChangePassword.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireChangePassword : LERequest


@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *passwordConfirm;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target newPassword:(NSString *)password newPasswordConfirm:(NSString *)passwordConfirm;


@end
