//
//  LECheckSpeciesName.h
//  DKTest
//
//  Created by Kevin Runde on 2/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LECheckSpeciesName : LERequest {
	NSString *name;
}


@property(nonatomic, retain) NSString *name;


- (LERequest *)initWithCallback:(SEL)inCallback target:(NSObject *)inTarget name:(NSString *)name;
- (BOOL)nameIsAvailable;


@end
