//
//  LEGetBody.h
//  DKTest
//
//  Created by Kevin Runde on 2/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEGetBody : LERequest {
	NSString *bodyId;
	NSDictionary *body;
}


@property(nonatomic, retain) NSString *bodyId;
@property(nonatomic, retain) NSDictionary *body;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target bodyId:(NSString *)bodyId;


@end
