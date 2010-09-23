//
//  LEEmpireGetSpeciesTemplates.h
//  UniversalClient
//
//  Created by Kevin Runde on 9/22/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireGetSpeciesTemplates : LERequest {
	NSMutableArray *templates;
}


@property(nonatomic, retain) NSMutableArray *templates;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target;


@end
