//
//  LEEmpireBoostBuilding.h
//  UniversalClient
//
//  Created by Bernard Kluskens on 8/20/12.
//  Copyright 2012 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireBoostBuilding : LERequest {
	NSDate *boostEndDate;
}


@property(nonatomic, retain) NSDate *boostEndDate;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target;


@end
