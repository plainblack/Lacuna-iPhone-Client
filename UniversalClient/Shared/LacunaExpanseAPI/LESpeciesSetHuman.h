//
//  LESpeciesSetHuman.h
//  DKTest
//
//  Created by Kevin Runde on 3/19/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LESpeciesSetHuman : LERequest {
	NSString *empireId;
}


@property(nonatomic, retain) NSString *empireId;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target empireId:(NSString *)empireId;


@end
