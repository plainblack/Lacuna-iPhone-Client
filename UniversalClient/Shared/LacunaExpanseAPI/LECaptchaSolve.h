//
//  LECaptchaSolve.h
//  UniversalClient
//
//  Created by Kevin Runde on 3/1/11.
//  Copyright 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LECaptchaSolve : LERequest {
}


@property (nonatomic, retain) NSString *captchaGuid;
@property (nonatomic, retain) NSString *captchaSolution;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target captchaGuid:(NSString *)captchaGuid captchaSolution:(NSString *)captchaSolution;


@end
