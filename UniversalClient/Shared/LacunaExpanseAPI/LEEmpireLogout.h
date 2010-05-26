//
//  LEEmpireLogout.h
//  DKTest
//
//  Created by Kevin Runde on 3/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireLogout : LERequest {
	NSString *sessionId;
	BOOL result;
}


@property(nonatomic, retain) NSString *sessionId;


- (BOOL)result;
- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target sessionId:(NSString *)sessionId;


@end
