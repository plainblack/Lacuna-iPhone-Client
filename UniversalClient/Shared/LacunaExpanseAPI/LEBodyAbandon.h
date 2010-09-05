//
//  LEBodyAbandon.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/4/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEBodyAbandon : LERequest {
	NSString *bodyId;
}


@property(nonatomic, retain) NSString *bodyId;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target forBody:(NSString *)bodyId;


@end
