//
//  LEEmpireFind.h
//  UniversalClient
//
//  Created by Kevin Runde on 8/27/10.
//  Copyright 2010 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LERequest.h"


@interface LEEmpireFind : LERequest {
	NSString *empireName;
	NSMutableArray *empiresFound;
}


@property (nonatomic, retain) NSString *empireName;
@property (nonatomic, retain) NSMutableArray *empiresFound;


- (LERequest *)initWithCallback:(SEL)callback target:(NSObject *)target empireName:(NSString *)empireName;


@end
