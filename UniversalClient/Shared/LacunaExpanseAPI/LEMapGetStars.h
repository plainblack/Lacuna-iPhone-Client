//
//  LEMapGetStars.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/26/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEMapGetStars : LERequest {
	NSDecimalNumber *topLeftX;
	NSDecimalNumber *topLeftY;
	NSDecimalNumber *bottomRightX;
	NSDecimalNumber *bottomRightY;
	NSMutableArray *stars;
}


@property (nonatomic, retain) NSDecimalNumber *topLeftX;
@property (nonatomic, retain) NSDecimalNumber *topLeftY;
@property (nonatomic, retain) NSDecimalNumber *bottomRightX;
@property (nonatomic, retain) NSDecimalNumber *bottomRightY;
@property (nonatomic, retain) NSMutableArray *stars;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target topLeftX:(NSDecimalNumber *)topLeftX topLeftY:(NSDecimalNumber *)topLeftY bottomRightX:(NSDecimalNumber *)bottomRightX bottomRightY:(NSDecimalNumber *)bottomRightY;


@end
