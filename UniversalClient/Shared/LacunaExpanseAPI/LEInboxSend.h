//
//  LEInboxSend.h
//  DKTest
//
//  Created by Kevin Runde on 3/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEInboxSend : LERequest {
	NSString *recipients;
	NSString *subject;
	NSString *body;
	NSDictionary *options;
	NSNumber *success;
}


@property(nonatomic, retain) NSString *recipients;
@property(nonatomic, retain) NSString *subject;
@property(nonatomic, retain) NSString *body;
@property(nonatomic, retain) NSDictionary *options;
@property(nonatomic, retain) NSNumber *success;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target recipients:(NSString *)recipients subject:(NSString *)subject body:(NSString *)body options:(NSDictionary *)options;


@end
