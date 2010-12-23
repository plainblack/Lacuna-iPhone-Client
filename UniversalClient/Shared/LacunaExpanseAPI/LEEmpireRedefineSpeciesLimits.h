//
//  LEEmpireRedefineSpeciesLimits.h
//  UniversalClient
//
//  Created by Kevin Runde on 12/20/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LERequest.h"


@interface LEEmpireRedefineSpeciesLimits : LERequest {
}


@property(nonatomic, retain) NSDecimalNumber *essentiaCost;
@property(nonatomic, retain) NSDecimalNumber *maxOrbit;
@property(nonatomic, retain) NSDecimalNumber *minOrbit;
@property(nonatomic, retain) NSDecimalNumber *minGrowth;
@property(nonatomic, assign) BOOL can;
@property(nonatomic, retain) NSString *reason;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target;


@end
