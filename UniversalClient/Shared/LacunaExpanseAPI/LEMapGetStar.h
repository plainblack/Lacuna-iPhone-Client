//
//  LEMapGetStar.h
//  UniversalClient
//
//  Created by Kevin Runde on 10/1/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEMapGetStar : LERequest {
	NSString *starId;
	NSMutableDictionary *star;
}


@property (nonatomic, retain) NSString *starId;
@property (nonatomic, retain) NSMutableDictionary *star;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target starId:(NSString *)starId;


@end
