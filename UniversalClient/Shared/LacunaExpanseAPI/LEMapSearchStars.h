//
//  LEMapSearchStars.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/29/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEMapSearchStars : LERequest {
	NSString *name;
	NSMutableArray *stars;
}


@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSMutableArray *stars;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target name:(NSString *)name;


@end
