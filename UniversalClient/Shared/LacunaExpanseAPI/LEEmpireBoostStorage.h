//
//  LEEmpireBoostStorage.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/10/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireBoostStorage : LERequest {
	NSDate *boostEndDate;
}


@property(nonatomic, retain) NSDate *boostEndDate;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target;


@end
