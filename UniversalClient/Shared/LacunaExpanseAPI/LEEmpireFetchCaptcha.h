//
//  LEEmpireFetchCaptcha.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireFetchCaptcha : LERequest {
	NSString *guid;
	NSString *url;
}


@property(nonatomic, retain) NSString *guid;
@property(nonatomic, retain) NSString *url;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target;


@end
