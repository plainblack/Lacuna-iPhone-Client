//
//  LEEmpireBoostSpyTraining.h
//  UniversalClient
//
//  Created by Bernard Kluskens on 02/23/16.
//  Copyright 2016 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireBoostSpyTraining : LERequest {
	NSDate *boostEndDate;
}


@property(nonatomic, retain) NSDate *boostEndDate;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target;


@end